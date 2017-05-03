function results = frontpro( fs,duration,p1,p2 )
%FRONTPRO Record the voice signal and save the voice as 'sample.wav', then
%calculate characteristic parameters using the signal.
%
%Inputs:
%       fs     sample rate in Hz (default 16000Hz)
%       duration     the recording time in seconds (default 5s)
%       p1     number of linear prediction cepstrum coefficients (default 20)
%       p2     number of mel-frequency cepstrum coefficients (default 12)
%
%Outputs:
%       results    an X-by-Y matrix. X depends on the voice signal and
%                  sample rate(fs). Y is p1+3p2+3(default 59)
%                  (1 to p1(20) are linear prediction cepstrum coefficients;
%                  p1+1(21) is log energy parameter;
%                  p1+2(22) to p1+p2+1(33) are mel-frequency cepstrum coefficients;
%                  p1+p2+2(34) to p1+2p2+2(46) are delta coefficients;
%                  p1+2p2+3(47) to p1+3p2+3(59) are delta-delta coefficients)
%

% Author Xiang Yingfei, 8-12-13
% Copyright 2013 TopBang Team
% $Date: 2013/08/12 01:34 $


%Process the input argument, if there are not enough argument, they will be
%assigned to default values
if nargin<1 
    fs=16000; 
end
if nargin<2
    duration=5; 
end
if nargin<3
    p1=20; 
end
if nargin<4
    p2=12; 
end

%Start recording, get the voice signals
fprintf('Press any key to start %g seconds of recording...\n',duration);
pause;
fprintf('Recording...\n');
s=wavrecord(duration*fs,fs);
fprintf('Finished recording.\n');

%Voice activity detection
vs=vadsohn(s,fs);
vss=find(vs==1);
ss=s(vss);

%Pre-emphasis with -0.9375 as the value of coefficient
sss = double(ss); 
sss = filter([1,-0.9375],1,sss); 

%Denoise using wavelet analysis
[c,l]=wavedec(sss',3,'db6');
sigma=wnoisest(c,l,1);
alpha=2; 
thr=wbmpen(c,l,sigma,alpha);
keepapp=1;
sss=wdencmp('gbl',c,l,'db6',3,thr,'s',keepapp);

%Get LPCC
%Frame and window the voice signals
flen=pow2(floor(log2(0.03*fs)));
y=enframe(sss,flen,flen/2);

%Calculate LPCC of every frame
[ya,yb]=size(y);
lpccs=zeros(ya,p1);
for i=1:ya
    yy=y(i,:);
    ar=lpcauto(yy,p1);
    cc=lpcar2cc(ar);
    lpccs(i,:)=cc;
end

%Get MFCC
mfccs=melcepst(sss,fs,'EdD',p2); 

%Combine LPCC and MFCC
results=[lpccs,mfccs];

end