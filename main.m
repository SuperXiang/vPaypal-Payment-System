function main ()
%MAIN  the main function of the program, you can just run this and follow
%the guide printed out.

% Author Xiang Yingfei, 8-27-13
% Copyright 2013 TopBang Team.
% $Date: 2013/08/27 22:03 $

%Get the voice signals of one people, they should say '12345' in Chinese.
fprintf('Please record the first voice signal...\n');
s1=frontpro;
fprintf('Please record the second voice signal...\n');
s2=frontpro;
fprintf('Please record the third voice signal...\n');
s3=frontpro;
fprintf('Building...\n');

%Build the BPnet
[net,in,out]=netbuild(s1,s2,s3);
fprintf('Finished building.\n');

%Do some tests
while 1
    i=input('Do you want to test?(y/n)\n','s');
    if i=='y'
        st=frontpro;
        match=jugg(net,st,in,out);
        if match==1
            fprintf('success...\n');
        else fprintf('failed...\n');
        end
    else break;
    end
end
end
