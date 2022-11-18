close all
clear all
load("../data/preprocessed/benny.mat")
fs = 128;
tw = 256;
slide = .5 * fs;

for i=(1:length(trailData))
    trail = trailData(i);
    n = fix((length(trail.eeg)-tw)/slide)+1;
    PSDs = zeros(n,29, 4);
    for s=(1:n)
        [psd freq] = pwelch(trail.eeg((s-1)*slide+1:(s-1)*slide+tw, :), ...
                        [], [], 256, fs);
        for c=(1:29)
            PSDs(s, c, :) = [mean(psd(all([(freq >= 5).';(freq <= 7).']), c)), ...
                            mean(psd(all([(freq >= 8).';(freq <= 13).']), c)), ...
                            mean(psd(all([(freq >= 14).'; (freq <= 29).']), c)), ...
                            mean(psd(all([(freq >= 30).';(freq <= 47).']), c))];
        end
    end

    figure
    x = (1:.5*fs:58*fs+1) /fs;
    plot(x, squeeze(mean(PSDs, 2)), LineWidth=2); hold on
%     xline([10 20 30 40 50 60]*fs, Color='r', LineWidth=2); hold off
    emotionTrajectory = sprintf("%d", trail.emotions);
    title(num2str(trail.music) + " : " + emotionTrajectory);
    legend(["Theta(5-7)", "alpha(8-13)", "beta(14-29)", "gamma(30-47)"])
    set(gca, 'fontsize', 14, 'fontname', 'arial', 'TickDir', 'out')
    saveas(gcf, "../results/benny/preprocessed/"+num2str(i)+"-"...
            +num2str(trail.music)+".jpg");
    close all

    trailData(i).psd = PSDs;
end

    
