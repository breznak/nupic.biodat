function [x] = plotECG(ecg)
  % parse ECG struct input
  e=ecg;
  % const
  baseline = 850;
  % plot
  % whole signal
  plot(e.steps, e.signal)
  hold all
  % annotated parts
  % for specific anomalies, change to =='V' , eg for Ventricular anomaly
  a = e.annot~='N'; % all not 'N' are anomalies
  idxA = find(a); % idx when the anomaly happens
% FIXME: why?
%  if(tn)
%    mask = isnan(sg);
%    mask(tn)=1;
%    whos mask
%    whos sg
%    plot(tn, e.signal(mask), 'g+')
%  end
  if idxA
    plot(e.steps(idxA), e.signal(idxA), 'r*')
    % highlight anomaly
    stem(e.steps(idxA),e.signal(idxA),'BaseValue',baseline,...
                                  'LineWidth',1,...
                                  'LineStyle','-',...
                                  'Color','red') 
  end;
  
 title('ECG anomaly')
 xlabel('sample [360Hz]')
 ylabel('ECG [mV]')
 legend('ECG','annotation-Normal','annotation-Anomaly','anomaly')
  
