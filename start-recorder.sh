filename=$(date +%Y-%m-%d___%H-%M-%S)
rec -t raw - | wavpack - -i -f --raw-pcm=48000,16,2 -o $filename.wv
ln -f $filename.wv last.wv
