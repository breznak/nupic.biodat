function [x] = plotECG(ecg)
  % parse ECG struct input
  steps = ecg.steps;
  signal = ecg.signal;
  time = ecg.times;
  annot = ecg.annot;
  % const
  n = annot=='N';
  ann = annot~='N'; % all not 'N' are anomalies
  hz=360;
  baseline = 850;
  high = 900;
  % plot
  hold all
  plot(steps, signal)
  plot(time(n),signal(n), 'g+')
  plot(time(ann), signal(ann), 'r*')
  % highlight anomaly
  stem(time(ann),ann(ann==1)*high,'BaseValue',baseline,...
                                  'LineWidth',3,...
                                  'LineStyle','-',...
                                  'Color','red') 
 title('ECG anomaly')
 xlabel('sample [360Hz]')
 ylabel('ECG [mV]')
 legend('ECG','annotation-Normal','annotation-Anomaly','anomaly')
  