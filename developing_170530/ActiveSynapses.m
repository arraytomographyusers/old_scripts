function ActiveSynapses(srcPath,channel1, channel2)

mkdir(srcPath,'\Results\ActiveSynapses');

[m,c,p] = size(channel1.BW);
to_reconst = logical(channel1.BW.*channel2.BW);
actsyn1 = imreconstruct(to_reconst, channel1.BW, 6);
actsyn2 = imreconstruct(to_reconst, channel2.BW, 6);
actsynjoin = or(actsyn1,actsyn2);

output1 = strcat(srcPath,'\Results\ActiveSynapses\',channel1.id,channel1.channel,'.tif');
output2 = strcat(srcPath,'\Results\ActiveSynapses\',channel1.id,channel2.channel,'.tif');
outputjoin = strcat(srcPath,'\Results\ActiveSynapses\',channel1.id,channel1.channel,channel2.channel,'.tif');

for i=1:p
    imwrite(uint16(actsyn1(:,:,i)),output1, 'WriteMode', 'append',  'Compression','none');
    imwrite(uint16(actsyn2(:,:,i)),output2, 'WriteMode', 'append',  'Compression','none');
    imwrite(uint16(actsynjoin(:,:,i)),outputjoin, 'WriteMode', 'append',  'Compression','none');
end