function [x] = plotECG(ecg)
  % parse ECG struct input
  e=ecg;
  % const
  hz=360;
  baseline = 850;
  high = 900;
  len=size(e.signal, 1);
  sg = e.signal;
  % plot
  hold all
  % whole signal
  plot(e.steps, e.signal)
  % annotated parts
  annHuman = e.annot(e.times);
  tn = e.times(annHuman=='N'); % tn = times of human annotations of 'N'
  ta = e.times(annHuman~='N'); % ta = times when human annotated as not 'N' = anomaly
  a = e.signal~='N'; % all not 'N' are anomalies
  if(tn)
    mask = isnan(sg);
    mask(tn)=1;
    whos mask
    whos sg
    plot(tn, e.signal(mask), 'g+')
  end
  if(ta)
    plot(ta, e.signal(ta), 'r*')
    % highlight anomaly
    stem(ta,e.signal(ta),'BaseValue',baseline,...
                                  'LineWidth',1,...
                                  'LineStyle','-',...
                                  'Color','red') 
  end
  
 title('ECG anomaly')
 xlabel('sample [360Hz]')
 ylabel('ECG [mV]')
 legend('ECG','annotation-Normal','annotation-Anomaly','anomaly')
  