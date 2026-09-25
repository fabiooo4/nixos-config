{inputs, pkgs, ...}: {
  config = {
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      antigravity-cli
    ];
  };
}
