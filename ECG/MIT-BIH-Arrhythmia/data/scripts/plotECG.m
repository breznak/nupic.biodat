function [anomalies] = plotECG(ecg, showAnomaly, desc)
%% plotECG()
% param ecg - the structure provided by loadECGSample() or sumsampleECG()
%       to be plotted
% param showAnomaly - which annotation should be highlighted as an anomaly,
%    'N' - normal, do not show any anomalies
%    'n' - all not-'N' - show anything not 'N'ormal as anomaly
%    'V' - highlight 'V'entricular anomalies
%     etc - as used in MIT-BIH annotations
% param desc - (string) title of the plot window
% return: indices where the given anomalies happen 
%

  e=ecg;
  % const
  baseline = 850;
  % plot
  % whole signal
  plot(e.steps, e.signal)
  hold all
  % annotated parts
  a=[];
  if showAnomaly == 'N' % don't plot anything
      a=[];
  elseif showAnomaly == 'n' % plot all not 'N'
      a = e.annot~='N'; % all not 'N' are anomalies
      %FIXME: ignore some annotations (end/beginning of ECG,...)
  else % plot specific anomalies 
      a = e.annot==showAnomaly;
  end
 
  idxA = find(a); % idx when the anomaly happens
  if idxA
    plot(e.steps(idxA), e.signal(idxA), 'r*')
    % highlight anomaly
    stem(e.steps(idxA),e.signal(idxA),'BaseValue',baseline,...
                                  'LineWidth',1,...
                                  'LineStyle','-',...
                                  'Color','red') 
  end
  
  anomalies = idxA; 
  
 title([desc])
 xlabel('sample [360Hz]')
 ylabel('ECG [mV]')
 legend('ECG','annotation-Normal','annotation-Anomaly','anomaly') 