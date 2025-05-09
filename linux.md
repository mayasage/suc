# Linux

## Disable laptop keyboard

You can use `xinput` to float the input device under X.

1. Execute the command `xinput list` to list your input devices.

2. Locate `AT Translated Set 2 keyboard` and take note of its `id` number; this will be used to disable the keyboard. 
   Also, take note of the number at the end, `[slave keyboard (#)]`; this is the id number of the `master`, which will 
   be used to re-enable your keyboard.

3. To disable the keyboard, execute the command `xinput float <id#>`, where `<id#>` is your keyboard's `id` number. For 
   example, if the `id` was `10`, then the command would be `xinput float 10`.

4. To re-enable the keyboard, execute the command `xinput reattach <id#> <master#>`, where `master` is that second 
   number we noted down. So if the number was `3`, you would do `xinput reattach 10 3`.

## Custom mouse click sounds

```shell

#!/bin/sh

expect -c '
spawn xmacrorec2
set timeout -1
expect  "ButtonPress 1" {
  system mpg321 '~/Desktop/mayasage/mouse-click-290204.mp3' &
  exp_continue          } \
 "ButtonPress 3" {
  system mpg321 '~/Desktop/mayasage/mouse-click-290204.mp3' &
  exp_continue        }
'

```
