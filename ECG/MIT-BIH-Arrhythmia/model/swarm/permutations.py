ECG_MIN = 850
ECG_MAX = 1311
NCOLS = 2048
NCELLS = 4
HZ=360
AHEAD=1
DATA_FILE=u'file://./inputdata.csv'
ITERATIONS=15000 # or -1 for whole dataset #override for swarming


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
        'ecgScalar': PermuteEncoder(fieldName='ecg', encoderClass='ScalarEncoder', resolution=PermuteChoices([0.2]), w=51, minval=ECG_MIN, maxval=ECG_MAX),
        'ecgDelta': PermuteEncoder(fieldName='ecg', encoderClass='DeltaEncoder', n=PermuteChoices([512, 1024, 2048]), w=51, minval=ECG_MIN, maxval=ECG_MAX),
      },
    },
  
  
    'spParams': {
      'columnCount': PermuteChoices([256, 512, 1024, 2048]),
    },

    'tpParams': {
      'cellsPerColumn': PermuteChoices([2, 4, 8, 16]),
      'pamLength': 5*HZ, #PermuteChoices([5, 10, 50, 100, 1*HZ, 5*HZ, 10*HZ, 30*HZ]),
    },

#    'anomalyParams': {
#      'mode': PermuteChoices(["pure", "likelihood", "weighted"]),
#      'slidingWindowSize': PermuteInt(0, 20),
#      'binaryAnomalyThreshold': PermuteFloat(0.0, 0.9),
#    },
  
  
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
minimize = "multiStepBestPredictions:multiStep:errorMetric='altMAPE':steps=1:window=1800:field=ecgScalar" #1800=5*HZ
#minimize = "prediction:anomaly:desiredPct=0.1:errorMetric='altMAPE':modelName='hotgymAnomalySwarmingDemo':steps=1:window=100:field=consumption"


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
  print perm 
  perm['modelParams']['tpParams']['columnCount']=perm['modelParams']['spParams']['columnCount']
  return True
