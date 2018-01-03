fs = 44100;
m = 2*fs;
c = zeros(1,m);

n = int32(fs/440.0*3);

b = rand(1,n) - 0.5;

for i=1:m
    b(mod(i-1,n) + 1) = 0.5*(b(mod(i-1,n) + 1) + b(mod(i,n) + 1));
    c(i) = b(mod(i-1,n) + 1);
end;

nBits = 16;
soundsc(c,fs, nBits);
spectrogram(c);