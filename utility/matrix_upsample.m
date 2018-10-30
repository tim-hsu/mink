%% Function - Upsample 3D Matrix Data
function M_output = matrix_upsample(M_input,scale)
M_input = double(M_input);

[X,Y,Z] = size(M_input);
M_output = zeros(X*scale,Y*scale,Z*scale);
j = 1;
for i = 1:Z*scale
    M_output(:,:,i) = kron(M_input(:,:,j),ones(scale));
    if rem(i,scale) == 0
        j = j + 1;
    end
end

M_output = uint8(M_output);
