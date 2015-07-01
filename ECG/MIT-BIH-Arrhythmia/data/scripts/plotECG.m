function [x] = plotECG(time, signal, annot)
  n = annot=='N';
  ann = annot~='N'; % all not 'N' are anomalies
  % plot
  hold all
  plot(signal)
  plot(time(n),signal(n), 'bo')
  plot(time(ann), signal(ann), 'r*')
  