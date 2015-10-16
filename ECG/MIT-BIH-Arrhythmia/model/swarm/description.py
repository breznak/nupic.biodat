ECG_MIN = 800
ECG_MAX = 1274
NCOLS = 2048
NCELLS = 4
HZ=360
AHEAD=1
DATA_FILE=u'file://./inputdata.csv'
ITERATIONS=-1 # or -1 for whole dataset #override for swarming

# ----------------------------------------------------------------------
# Numenta Platform for Intelligent Computing (NuPIC)
# Copyright (C) 2013, Numenta, Inc.  Unless you have an agreement
# with Numenta, Inc., for a separate license for this software code, the
# following terms and conditions apply:
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# http://numenta.org/licenses/
# ----------------------------------------------------------------------

from nupic.frameworks.opf.expdescriptionapi import ExperimentDescriptionAPI

from nupic.frameworks.opf.expdescriptionhelpers import (
  updateConfigFromSubConfig,
  applyValueGettersToContainer,
  DeferredDictLookup)

from nupic.frameworks.opf.clamodelcallbacks import *
from nupic.frameworks.opf.metrics import MetricSpec
from nupic.frameworks.opf.opfutils import (InferenceType,
                                           InferenceElement)
from nupic.support import aggregationDivide

from nupic.frameworks.opf.opftaskdriver import (
                                            IterationPhaseSpecLearnOnly,
                                            IterationPhaseSpecInferOnly,
                                            IterationPhaseSpecLearnAndInfer)
from nupic.algorithms.anomaly import Anomaly


# Model Configuration Dictionary:
#
# Define the model parameters and adjust for any modifications if imported
# from a sub-experiment.
#
# These fields might be modified by a sub-experiment; this dict is passed
# between the sub-experiment and base experiment
#
config = {
    # Type of model that the rest of these parameters apply to.
    'model': "CLA",

    # Version that specifies the format of the config.
    'version': 1,
    'predictAheadTime': None,

    # Model parameter dictionary.
    'modelParams': {
        # The type of inference that this model will perform
        'inferenceType': 'TemporalAnomaly',

        'sensorParams': {
            # Sensor diagnostic output verbosity control;
            # if > 0: sensor region will print out on screen what it's sensing
            # at each step 0: silent; >=1: some info; >=2: more info;
            # >=3: even more info (see compute() in py/regions/RecordSensor.py)
            'verbosity' : 0,

            # TODO change settings here
            'encoders': {   
              'ecgScalar': {   
                 'fieldname': u'ecg',
                 'resolution': 0.2,
                 'name': u'ecgScalar',
                 'type': 'ScalarEncoder',
                 'minval': ECG_MIN,
                 'maxval': ECG_MAX,
                 'w': 51},

              'ecgDelta': {
                 'fieldname': u'ecg',
                 'n': 1024,
                 'name': u'ecgDelta',
                 'type': 'DeltaEncoder',
                 'minval': ECG_MIN,
                 'maxval': ECG_MAX,
                 'w': 51},

            },

            'sensorAutoReset' : None,
        },

        'spEnable': True,

        'spParams': {
            # SP diagnostic output verbosity control;
            # 0: silent; >=1: some info; >=2: more info;
            'spVerbosity' : 0,
            'spatialImp': 'cpp',

            'globalInhibition': 1,

            # Number of cell columns in the cortical region (same number for
            # SP and TP)
            # (see also tpNCellsPerCol)
            'columnCount': NCOLS,

            'inputWidth': 0,

            # SP inhibition control (absolute value);
            # Maximum number of active columns in the SP region's output (when
            # there are more, the weaker ones are suppressed)
            'numActiveColumnsPerInhArea': 40,

            'seed': 1956,

            # coincInputPoolPct
            # What percent of the columns's receptive field is available
            # for potential synapses. At initialization time, we will
            # choose coincInputPoolPct * (2*coincInputRadius+1)^2
            'potentialPct': 0.5,

            # The default connected threshold. Any synapse whose
            # permanence value is above the connected threshold is
            # a "connected synapse", meaning it can contribute to the
            # cell's firing. Typical value is 0.10. Cells whose activity
            # level before inhibition falls below minDutyCycleBeforeInh
            # will have their own internal synPermConnectedCell
            # threshold set below this default value.
            # (This concept applies to both SP and TP and so 'cells'
            # is correct here as opposed to 'columns')
            'synPermConnected': 0.1,

            'synPermActiveInc': 0.05,

            'synPermInactiveDec': 0.01,
        },

        # Controls whether TP is enabled or disabled;
        # TP is necessary for making temporal predictions, such as predicting
        # the next inputs.  Without TP, the model is only capable of
        # reconstructing missing sensor inputs (via SP).
        'tpEnable' : True,

        'tpParams': {
            # TP diagnostic output verbosity control;
            # 0: silent; [1..6]: increasing levels of verbosity
            # (see verbosity in nupic/trunk/py/nupic/research/TP.py and TP10X*.py)
            'verbosity': 0,

            # Number of cell columns in the cortical region (same number for
            # SP and TP)
            # (see also tpNCellsPerCol)
            'columnCount': NCOLS,

            # The number of cells (i.e., states), allocated per column.
            'cellsPerColumn': NCELLS,

            'inputWidth': NCOLS,

            'seed': 1960,

            # Temporal Pooler implementation selector (see _getTPClass in
            # CLARegion.py).
            'temporalImp': 'cpp',

            # New Synapse formation count
            # NOTE: If None, use spNumActivePerInhArea
            #
            # TODO: need better explanation
            'newSynapseCount': 20,

            # Maximum number of synapses per segment
            #  > 0 for fixed-size CLA
            # -1 for non-fixed-size CLA
            #
            # TODO: for Ron: once the appropriate value is placed in TP
            # constructor, see if we should eliminate this parameter from
            # description.py.
            'maxSynapsesPerSegment': 32,

            # Maximum number of segments per cell
            #  > 0 for fixed-size CLA
            # -1 for non-fixed-size CLA
            #
            # TODO: for Ron: once the appropriate value is placed in TP
            # constructor, see if we should eliminate this parameter from
            # description.py.
            'maxSegmentsPerCell': 128,

            # Initial Permanence
            # TODO: need better explanation
            'initialPerm': 0.21,

            # Permanence Increment
            'permanenceInc': 0.05,

            # Permanence Decrement
            # If set to None, will automatically default to tpPermanenceInc
            # value.
            'permanenceDec' : 0.01,

            'globalDecay': 0.0,
            'maxAge': 0,

            # Minimum number of active synapses for a segment to be considered
            # during search for the best-matching segments.
            # None=use default
            # Replaces: tpMinThreshold
            'minThreshold': 12,

            # Segment activation threshold.
            # A segment is active if it has >= tpSegmentActivationThreshold
            # connected synapses that are active due to infActiveState
            # None=use default
            # Replaces: tpActivationThreshold
            'activationThreshold': 12,

            'outputType': 'normal',

            # "Pay Attention Mode" length. This tells the TP how many new
            # elements to append to the end of a learned sequence at a time.
            # Smaller values are better for datasets with short sequences,
            # higher values are better for datasets with long sequences.
            'pamLength': 5*HZ,
        },

        'clParams': {
            # Classifier implementation selection.
            'implementation': 'cpp',
            'regionName' : 'CLAClassifierRegion',

            # Classifier diagnostic output verbosity control;
            # 0: silent; [1..6]: increasing levels of verbosity
            'clVerbosity' : 0,

            # This controls how fast the classifier learns/forgets. Higher values
            # make it adapt faster and forget older patterns faster.
            'alpha': 0.000001,

            # This is set after the call to updateConfigFromSubConfig and is
            # computed from the aggregationInfo and predictAheadTime.
            'steps': AHEAD, # we need to predict just 1-ahead
        },

        'anomalyParams': {
           'mode': Anomaly.MODE_PURE, # pure(=default) / weighted / likelihood
           'slidingWindowSize': None, # >=0 / None
           'anomalyBinaryThreshold': None, #0.5,
        },

        'trainSPNetOnlyIfRequested': False,
    },


  'predictionSteps': [AHEAD],
  'predictedField': 'ecg',
}
# end of config dictionary


# Adjust base config dictionary for any modifications if imported from a
# sub-experiment
updateConfigFromSubConfig(config)


# Compute predictionSteps based on the predictAheadTime and the aggregation
# period, which may be permuted over.
if config['predictAheadTime'] is not None:
  predictionSteps = int(round(aggregationDivide(
      config['predictAheadTime'], config['aggregationInfo'])))
  assert (predictionSteps >= 1)
  config['modelParams']['clParams']['steps'] = str(predictionSteps)


# Adjust config by applying ValueGetterBase-derived
# futures. NOTE: this MUST be called after updateConfigFromSubConfig() in order
# to support value-getter-based substitutions from the sub-experiment (if any)
applyValueGettersToContainer(config)
control = {
  # The environment that the current model is being run in
  "environment": 'nupic',
#FIXME  'swarmSize': 'medium',


  # Input stream specification per py/nupic/cluster/database/StreamDef.json.
  #
  'dataset' : {
        u'info': u'ecg_file',
        u'streams': [   {   u'columns': [u'*'],
                            u'info': u'ECG file',
                            u'source': DATA_FILE}],
        u'version': 1},


  ### SWARMING settings: 

  # Iteration count: maximum number of iterations.  Each iteration corresponds
  # to one record from the (possibly aggregated) dataset.  The task is
  # terminated when either number of iterations reaches iterationCount or
  # all records in the (possibly aggregated) database have been processed,
  # whichever occurs first.
  #
  # iterationCount of -1 = iterate over the entire dataset
  'iterationCount' : ITERATIONS, 


  # A dictionary containing all the supplementary parameters for inference
  "inferenceArgs":{'predictedField': config['predictedField'],
                   'predictionSteps': config['predictionSteps']},

  # Metrics: A list of MetricSpecs that instantiate the metrics that are
  # computed for this experiment
  'metrics':[],

  # Logged Metrics: A sequence of regular expressions that specify which of
  # the metrics from the Inference Specifications section MUST be logged for
  # every prediction. The regex's correspond to the automatically generated
  # metric labels. This is similar to the way the optimization metric is
  # specified in permutations.py.
  'loggedMetrics': ['.*aae.*'],
}

# Add multi-step prediction metrics
for steps in config['predictionSteps']:
  control['metrics'].append(
      MetricSpec(field=config['predictedField'], metric='multiStep',
                 inferenceElement='multiStepBestPredictions',
                 params={'errorMetric': 'aae', 'window': 1000, 'steps': steps}))
  control['metrics'].append(
      MetricSpec(field=config['predictedField'], metric='trivial',
                 inferenceElement='prediction',
                 params={'errorMetric': 'aae', 'window': 1000, 'steps': steps}))
  control['metrics'].append(
      MetricSpec(field=config['predictedField'], metric='multiStep',
                 inferenceElement='multiStepBestPredictions',
                 params={'errorMetric': 'altMAPE', 'window': 5*HZ, 'steps': steps}))
  control['metrics'].append(
      MetricSpec(field=config['predictedField'], metric='trivial',
                 inferenceElement='prediction',
                 params={'errorMetric': 'altMAPE', 'window': 1000, 'steps': steps}))

################################################################################
################################################################################
descriptionInterface = ExperimentDescriptionAPI(modelConfig=config,
                                                control=control)
