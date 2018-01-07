Fs = 44100;

A = 110;

Eoffset  = -5;
Doffset  = 5;
Goffset  = 10;
Boffset  = 14;
E2offset = 19;

sn = 4;
x = zeros(Fs*sn, 1);

F = linspace(1/Fs, 1000, 2^12);

delay = round(Fs/A);

b  = firls(42, [0 1/delay 2/delay 1], [0 0 1 1]);
a  = [1 zeros(1, delay) -0.5 -0.5];

[H,W] = freqz(b, a, F, Fs);
plot(W, 20*log10(abs(H)));
title('Harmonics of an open A string');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

zi = rand(max(length(b),length(a))-1,1);
note = filter(b, a, x, zi);

note = note-mean(note);
note = note/max(abs(note));

fret  = 4;
delay = round(Fs/(A*2^(fret/12)));

b  = firls(42, [0 1/delay 2/delay 1], [0 0 1 1]);
a  = [1 zeros(1, delay) -0.5 -0.5];

[H,W] = freqz(b, a, F, Fs);
hold on
plot(W, 20*log10(abs(H)), 'r');
title('Harmonics of the A string');
legend('Open A string', 'A string on the 4th fret');

zi = rand(max(length(b),length(a))-1,1);
note = filter(b, a, x, zi);

note = note-mean(note);
note = note/max(note);

fret = [3 3 2 0 1 3];

delay = [round(Fs/(A*2^((fret(1)+Eoffset)/12))), ...
    round(Fs/(A*2^(fret(2)/12))), ...
    round(Fs/(A*2^((fret(3)+Doffset)/12))), ...
    round(Fs/(A*2^((fret(4)+Goffset)/12))), ...
    round(Fs/(A*2^((fret(5)+Boffset)/12))), ...
    round(Fs/(A*2^((fret(6)+E2offset)/12)))];

  
b = cell(length(delay),1);
a = cell(length(delay),1);
H = zeros(length(delay),4096);
note = zeros(length(x),length(delay));
for indx = 1:length(delay)    
    
    b{indx} = firls(42, [0 1/delay(indx) 2/delay(indx) 1], [0 0 1 1]).';
    a{indx} = [1 zeros(1, delay(indx)) -0.5 -0.5].';    
   
    zi = rand(max(length(b{indx}),length(a{indx}))-1,1);
    
    note(:, indx) = filter(b{indx}, a{indx}, x, zi);
    
    
    note(:, indx) = note(:, indx)-mean(note(:, indx));
    
    [H(indx,:),W] = freqz(b{indx}, a{indx}, F, Fs);
end

hline = plot(W, 20*log10(abs(H.')));
title('Harmonics of the C chord');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend(hline, 'E','A','D','G','B','E2');

combinedNote = sum(note,2);
combinedNote = combinedNote/max(abs(combinedNote));

hplayer = audioplayer(combinedNote, Fs); play(hplayer)


offset = 50; 
offset = ceil(offset*Fs/1000);