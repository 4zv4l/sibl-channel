# sibl-channel

My Guix Channel

## How to add

Simply add this to your `channel.scm`

```scm
(channel
  (name 'sibl)
  (url "https://github.com/4zv4l/sibl-channel")
  (branch "main")
  (introduction
    (make-channel-introduction
      "b4b9d2fa01b78bbdb4314008424dc01dda1de20a"
      (openpgp-fingerprint
        "F656 64BF 2D60 DA21 095F  CA50 7FD2 BABC CDDE 5BF1"))))
```
