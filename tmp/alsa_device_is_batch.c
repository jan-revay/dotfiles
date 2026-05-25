// Use `arecord -l resp. aplay -l` to list all capture/playback devices.
//
// example usage:
//   $ ./a.out hw:4,0 capture


#include <stdio.h>
#include <stdlib.h>
#include <alsa/asoundlib.h>

int main(int argc, char **argv) {
    snd_pcm_t *pcm = NULL;
    snd_pcm_hw_params_t *params;
    const char *dev;
    snd_pcm_stream_t stream = SND_PCM_STREAM_PLAYBACK;
    int err, is_batch;

    if (argc < 2 || argc > 3) {
        fprintf(stderr, "Usage: %s <device> [playback|capture]\n", argv[0]);
        return 2;
    }

    dev = argv[1];
    if (argc == 3) {
        if (!strcmp(argv[2], "capture")) {
            stream = SND_PCM_STREAM_CAPTURE;
        } else if (strcmp(argv[2], "playback")) {
            fprintf(stderr, "Second argument must be playback or capture\n");
            return 2;
        }
    }

    err = snd_pcm_open(&pcm, dev, stream, 0);
    if (err < 0) {
        fprintf(stderr, "snd_pcm_open(%s) failed: %s\n", dev, snd_strerror(err));
        return 1;
    }

    snd_pcm_hw_params_alloca(&params);

    err = snd_pcm_hw_params_any(pcm, params);
    if (err < 0) {
        fprintf(stderr, "snd_pcm_hw_params_any() failed: %s\n", snd_strerror(err));
        snd_pcm_close(pcm);
        return 1;
    }

    is_batch = snd_pcm_hw_params_is_batch(params);

    printf("device=%s stream=%s is_batch=%d\n",
           dev,
           stream == SND_PCM_STREAM_CAPTURE ? "capture" : "playback",
           is_batch > 0 ? 1 : 0);

    snd_pcm_close(pcm);
    return 0;
}
