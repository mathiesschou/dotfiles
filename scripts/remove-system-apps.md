# Remove macOS System Apps

## Steps

1. Shut down your Mac
2. Hold the power button until you see "Loading startup options"
3. Click **Options** → Continue
4. Open **Terminal** from the menu bar
5. Run `csrutil disable` and restart

6. Once booted, run the script:
   ```sh
   bash ~/dotfiles/scripts/remove-system-apps.sh
   ```

7. Boot into Recovery again and run `csrutil enable`
