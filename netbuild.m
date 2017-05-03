function [net,inputps,outputps] = netbuild(s1,s2,s3)
%NETBUILD  build a BPnet to recognize audio signals. 
%       ps: when building BPnet, this function uses voice signals of others 
%              for comparision ( noise.mat ) 
%
%Inputs:
%       s1 & s2 & s3     the voice signal of one person using to train 
%                        the net
%       
%Outputs:
%       net                    the net that has been trained
%       inputps & outputps     the parameters for function mapminmax
%

% Author Xiang Yingfei, 08/27/2013
% Copyright 2013 TopBang Team.
% $Date: 08/27/2013 21:05 $

%Open the file-noise.mat to read the voice signals for comparision
noise = struct2cell(open('noise.mat'));

%Get the length of every signal and save the noises' length to vector nlen
nn = size(noise,1);
for i=1:nn
    nlen(i) = size(cell2mat(noise(i)),1);
end
ns1=size(s1,1);
ns2=size(s2,1);
ns3=size(s3,1);

%Form the input matrix for training-trainin
trainin=[s1(:,21:59);s2(:,21:59);s3(:,21:59)];
for i=1:nn
    mat=cell2mat(noise(i));
    trainin=[trainin;mat(:,21:59)];
end

%Form the output matrix for training-trainout
for i=1:ns1+ns2+ns3
    trainout(i,:)=[0 1];
end
for i=ns1+ns2+ns3+1 : ns1+ns2+ns3+sum(nlen)
    trainout(i,:)=[1 0];
end

%Pick out the training input and output matrix randomly
k=rand(1, ns1+ns2+ns3+sum(nlen));
[m,n]=sort(k);
input_train=trainin(n(1:ns1+ns2+ns3+sum(nlen)),:)';
output_train=trainout(n(1:ns1+ns2+ns3+sum(nlen)),:)';


%Map the matrixs above row minimum and maximum values to [-1 1].
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%Build the BPnet
net=newff(inputn,outputn,40);

%Set the parameters of the BPnet
net.trainParam.epochs=50;
net.trainParam.lr=0.36;
net.trainParam.mc=0.85;
net.trainParam.goal=0.00001;

%Start training
net=train(net,inputn,outputn);

end