ECG_MIN = 850
ECG_MAX = 1311
NCOLS = 2048
HZ=360
DATA_FILE=u'file:///home/mmm/devel/ecg/nupic.biodat/ECG/MIT-BIH-Arrhythmia/data/out.csv'
ITERATIONS=-1 # or -1 for whole dataset


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


from nupic.swarming.permutationhelpers import *

# The name of the field being predicted.  Any allowed permutation MUST contain
# the prediction field.
# (generated from PREDICTION_FIELD)
predictedField = 'ecg'

permutations = {
  
  'modelParams': {
  
    'sensorParams': {
      'encoders': {
        'ecg': PermuteEncoder(fieldName='ecg', encoderClass='ScalarEncoder', resolution=PermuteChoices([0.2, 0.02, 0.1, 0.5]), w=PermuteChoices([31, 51, 91]), minval=ECG_MIN, maxval=ECG_MAX),
      },
    },
  
  
    'tpParams': {
      'minThreshold': PermuteInt(9, 12),
      'activationThreshold': PermuteInt(12, 16),
      'pamLength': PermuteChoices([5, 10, 50, 100, 1*HZ, 5*HZ, 10*HZ, 30*HZ]),
    },

    'anomalyParams': {
      'mode': PermuteChoices(["pure", "likelihood", "weighted"]),
      'slidingWindowSize': PermuteInt(0, 20),
      'binaryAnomalyThreshold': PermuteFloat(0.0, 0.9),
    },
  
  
  }
}


# Fields selected for final hypersearch report;
# NOTE: These values are used as regular expressions by RunPermutations.py's
#       report generator
# (fieldname values generated from PERM_PREDICTED_FIELD_NAME)
report = [
          '.*ecg.*',
         ]

# Permutation optimization setting: either minimize or maximize metric
# used by RunPermutations.
# NOTE: The value is used as a regular expressions by RunPermutations.py's
#       report generator
# (generated from minimize = 'prediction:aae:window=1000:field=consumption')
#minimize = "multiStepBestPredictions:multiStep:errorMetric='aae':steps=1:window=1000:field=consumption"
minimize = "prediction:anomaly:desiredPct=0.1:errorMetric='altMAPE':modelName='hotgymAnomalySwarmingDemo':steps=1:window=100:field=consumption"


#############################################################################
def permutationFilter(perm):
  """ This function can be used to selectively filter out specific permutation
  combinations. It is called by RunPermutations for every possible permutation
  of the variables in the permutations dict. It should return True for valid a
  combination of permutation values and False for an invalid one. 
  
  Parameters:
  ---------------------------------------------------------
  perm: dict of one possible combination of name:value
        pairs chosen from permutations.
  """
  
  # An example of how to use this
  #if perm['__consumption_encoder']['maxval'] > 300:
  #  return False;
  # 
  return True
