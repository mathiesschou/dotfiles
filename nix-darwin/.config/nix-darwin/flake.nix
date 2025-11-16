{
	description = "mathies nix-darwin config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		nix-homebrew.url = "github:zhaofengli/nix-homebrew";
	};

	outputs = { self, nix-darwin, nixpkgs, nix-homebrew }: {
		darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
			system = "aarch64-darwin";
			modules = [
				nix-homebrew.darwinModules.nix-homebrew
				{
					nix-homebrew = {
						enable = true;
						enableRosetta = false;
						user = "mathies";
					};
				}
				({ pkgs, ... }: {
					environment.systemPackages = with pkgs; [
						neovim
						git
						stow
						zsh-powerlevel10k
					];					
				
				homebrew = {
					enable = true;

					casks = [
						"ghostty"
						"zoom"
						"font-meslo-lg-nerd-font"
					];

					onActivation = {
						cleanup = "zap";
						autoUpdate = true;
						upgrade = true;
					};
				};

				
					nix.settings.experimental-features = "nix-command flakes";
					programs.zsh.enable = true;
					programs.zsh = {
						promptInit = ''
						source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
							'';
					};



					system.stateVersion = 5;
					system.primaryUser = "mathies";

					system.keyboard = {
						enableKeyMapping = true;
						remapCapsLockToControl = true;
					};

					system.activationScripts.extraActivation.text = ''
# Apply settings immediately
						/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Run setup script as user (we're root, so use sudo -u)
						echo "Running default terminal setup..."
						/usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./set-default-terminal.sh}


# Setup SSH key
					echo "Checking SSH setup.."
						/usr/bin/sudo -u mathies /usr/bin/env HOME=/Users/mathies /bin/bash ${./setup-ssh.sh}

					'';

					
					nixpkgs.hostPlatform = "aarch64-darwin";


					users.users.mathies = {
						name = "mathies";
						home = "/Users/mathies";
					};
				})	
			];
		};
	};
}
