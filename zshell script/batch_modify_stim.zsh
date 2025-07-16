#!/bin/zsh

# Read the header and all rows from probabilities.csv
csv="x_biased_prob.csv"
header=$(head -1 $csv)
tail -n +2 $csv | while IFS=, read -r eta p px py pz pix piy piz pxi pxx pxy pxz pyi pyx pyy pyz pzi pzx pzy pzz; do
  # For each stim file
  for file in *.stim; do
    # Extract d, n, p from filename
    base="${file%%.stim}"
    d=$(echo $base | sed -n 's/.*d=\([0-9]*\).*/\1/p')
    # Compose new filename in the required format
    newfile="d=${d},n=${eta},p=${p},noise=XB,b=y,r=3d,ro=unro,st=ZY,idl=y.stim"
    echo "Creating $newfile"
    cp "$file" "$newfile"

    # Replace Z_ERROR
    sed -i "" "s/Z_ERROR([0-9.eE+\-]*)/Z_ERROR($pz)/g" "$newfile"
    # Replace X_ERROR
    sed -i "" "s/X_ERROR([0-9.eE+\-]*)/X_ERROR($px)/g" "$newfile"
    # Replace Y_ERROR
    sed -i "" "s/Y_ERROR([0-9.eE+\-]*)/Y_ERROR($py)/g" "$newfile"
    # Replace DEPOLARIZE1
    sed -i "" "s/DEPOLARIZE1([0-9.eE+\-]*)/PAULI_CHANNEL_1($px, $py, $pz)/g" "$newfile"
    # Replace DEPOLARIZE2
    sed -i "" "s/DEPOLARIZE2([0-9.eE+\-]*)/PAULI_CHANNEL_2($pix, $piy, $piz, $pxi, $pxx, $pxy, $pxz, $pyi, $pyx, $pyy, $pyz, $pzi, $pzx, $pzy, $pzz)/g" "$newfile"
    # Replace PAULI_CHANNEL_1
    sed -i "" "s/PAULI_CHANNEL_1([0-9.eE+, \-]*)/PAULI_CHANNEL_1($px, $py, $pz)/g" "$newfile"
    # Replace PAULI_CHANNEL_2
    sed -i "" "s/PAULI_CHANNEL_2([0-9.eE+, \-]*)/PAULI_CHANNEL_2($pix, $piy, $piz, $pxi, $pxx, $pxy, $pxz, $pyi, $pyx, $pyy, $pyz, $pzi, $pzx, $pzy, $pzz)/g" "$newfile"
  done
done