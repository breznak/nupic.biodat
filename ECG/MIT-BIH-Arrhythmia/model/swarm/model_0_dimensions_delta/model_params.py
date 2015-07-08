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

MODEL_PARAMS = {'model': 'CLA',
 'modelParams': {'anomalyParams': {'anomalyBinaryThreshold': None,
                                   'mode': 'pure',
                                   'slidingWindowSize': None},
                 'clParams': {'alpha': 0.0001,
                              'clVerbosity': 0,
                              'implementation': 'cpp',
                              'regionName': 'CLAClassifierRegion',
                              'steps': 1},
                 'inferenceType': 'TemporalAnomaly',
                 'sensorParams': {'encoders': {'ecg': {'clipInput': True,
                                                       'fieldname': 'ecg',
                                                       'maxval': 1311,
                                                       'minval': 850,
                                                       'n': 1024,
                                                       'name': 'ecg',
                                                       'type': 'DeltaEncoder',
                                                       'w': 51}},
                                  'sensorAutoReset': None,
                                  'verbosity': 0},
                 'spEnable': True,
                 'spParams': {'columnCount': 512,
                              'globalInhibition': 1,
                              'inputWidth': 0,
                              'numActiveColumnsPerInhArea': 40,
                              'potentialPct': 0.5,
                              'seed': 1956,
                              'spVerbosity': 0,
                              'spatialImp': 'cpp',
                              'synPermActiveInc': 0.1,
                              'synPermConnected': 0.1,
                              'synPermInactiveDec': 0.01},
                 'tpEnable': True,
                 'tpParams': {'activationThreshold': 12,
                              'cellsPerColumn': 4,
                              'columnCount': 512,
                              'globalDecay': 0.0,
                              'initialPerm': 0.21,
                              'inputWidth': 256,
                              'maxAge': 0,
                              'maxSegmentsPerCell': 128,
                              'maxSynapsesPerSegment': 32,
                              'minThreshold': 12,
                              'newSynapseCount': 20,
                              'outputType': 'normal',
                              'pamLength': 1800,
                              'permanenceDec': 0.1,
                              'permanenceInc': 0.1,
                              'seed': 1960,
                              'temporalImp': 'cpp',
                              'verbosity': 0},
                 'trainSPNetOnlyIfRequested': False},
 'predictAheadTime': None,
 'predictedField': 'ecg',
 'predictionSteps': [1],
 'version': 1}