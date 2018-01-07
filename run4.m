fs = 44100; 
duration = 3;
N = fs * duration;
K = int32(100);
A = 110;  
decay = 0.99;

snd = zeros(1, N);

d = rand(1,K+1);

for i=1:N
    index1 = mod(i-1,K) + 1;
    index2 = mod(i,K) + 1;
    d(index1) = decay*(d(index2) + d(index1))/2;
    snd(i) = d(index1);  
end;

plot(snd);

hplayer = audioplayer(snd, fs); play(hplayer)


