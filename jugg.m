function match = jugg(net,test,inputps,outputps)
%JUGG  Judge if the input voice signal match the net that has trained
%      before
%
%Inputs:
%       net     the net that has trained before
%       test     the input voice signal
%       inputps & outputps    the parameters for function mapminmax
%
%Outputs:
%       match    if the voice signal is the voice of the person that the net
%                trained for, the value is 1, else 0;
%

% Author Xiang Yingfei, 8-27-13
% Copyright 2013 TopBang Team.
% $Date: 2013/08/27 21:45 $

input_test=test(:,21:59)'; 
inputn_test=mapminmax('apply',input_test,inputps);
an=sim(net,inputn_test);
BPoutput=mapminmax('reverse',an,outputps);
avg=mean(BPoutput,2);
if avg(1)<0.4&&avg(2)>0.6
    match=1;
else match=0;
end

end
