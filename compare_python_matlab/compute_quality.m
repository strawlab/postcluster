load('generated_data') % loads X, codebook0, codebook1, codebook2, codebook3, IDX1, SUMD

[num_cent num_feat] = size( codebook0 );
all_codebooks = zeros(num_cent,num_feat,4);
all_codebooks(:,:,1) = codebook0;
all_codebooks(:,:,2) = codebook1;
all_codebooks(:,:,3) = codebook2;
all_codebooks(:,:,4) = codebook3;

addpath('../braun_geurten_egelhaaf/Eval');

instability = pbc_calcCentroidInstability( all_codebooks );

[qualities] = pbc_calcClusterQuality(codebook0, IDX1, SUMD);
quality = qualities(:,4);

disp(sprintf("instability: %.5f",instability));
disp(sprintf("quality: [%.5f, %.5f]",quality(1), quality(2)));
