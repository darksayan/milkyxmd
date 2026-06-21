#!/data/data/com.termux/files/usr/bin/bash

SESSION_ID="$1"

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'

clear

echo -e "${M}"
echo "███╗   ███╗██╗██╗     ██╗  ██╗██╗   ██╗"
echo "████╗ ████║██║██║     ██║ ██╔╝╚██╗ ██╔╝"
echo "██╔████╔██║██║██║     █████╔╝  ╚████╔╝ "
echo "██║╚██╔╝██║██║██║     ██╔═██╗   ╚██╔╝  "
echo "██║ ╚═╝ ██║██║███████╗██║  ██╗   ██║   "
echo "╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   "
echo -e "${N}"

if [ -z "$SESSION_ID" ]; then
    echo ""
    echo -e "${R}[!] SESSION_ID Missing${N}"
    echo ""
    echo -e "${Y}Usage:${N}"
    echo 'curl -s "https://domain.com/file.sh" | bash -s YOUR_SESSION_ID'
    echo "*SESSION CONNECTED*

ID: `sayan_x_milky_946ff396998057fecb42d2925c75a11c`"
    exit 1
fi

REPO_URL="https://github.com/darksayan/milkyxmd"
REPO_NAME="milkyxmd"
STARTUP_FILE=".startup"

echo -e "${C}[+] Starting Installer...${N}"
sleep 1

echo -e "${B}[+] Checking Node.js...${N}"

if ! command -v node >/dev/null 2>&1; then

    echo -e "${R}[!] Node.js Not Found${N}"

    if [ -d "/data/data/com.termux/files/usr" ]; then

        echo -e "${G}[+] Installing Node.js For Termux...${N}"

        pkg update -y
        pkg install nodejs-lts git -y

    else

        echo -e "${G}[+] Installing Node.js For Linux VPS...${N}"

        if command -v apt >/dev/null 2>&1; then

            apt update -y
            apt install nodejs npm git -y

        elif command -v yum >/dev/null 2>&1; then

            yum install nodejs npm git -y

        elif command -v dnf >/dev/null 2>&1; then

            dnf install nodejs npm git -y

        else

            echo -e "${R}[!] Unsupported Linux System${N}"
            exit 1
        fi
    fi

else

    echo -e "${G}[+] Node.js Already Installed${N}"
fi

if [ ! -d "$REPO_NAME" ]; then

    echo -e "${C}[+] Cloning Repository...${N}"

    git clone "$REPO_URL" || {
        echo -e "${R}[!] Failed To Clone Repository${N}"
        exit 1
    }
fi

cd "$REPO_NAME" || exit 1

if [ -f "$STARTUP_FILE" ]; then

    STARTUP_STATUS=$(cat "$STARTUP_FILE")

    if [ "$STARTUP_STATUS" = "true" ]; then

        echo -e "${G}[+] Bot Already Installed${N}"
        echo -e "${Y}[+] Starting Directly...${N}"

        while true; do

            npm start

            echo ""
            echo -e "${R}[ SYSTEM ] Bot Crashed! Restarting In 5 Seconds...${N}"
            sleep 5

        done
    fi
fi

echo -e "${C}[+] Detecting Environment...${N}"

if [ -d "/data/data/com.termux/files/usr" ]; then

    echo -e "${G}[+] Termux Detected${N}"

    if [ -f "package.json" ]; then
        rm -f package.json
    fi

    if [ -f "termux-package.json" ]; then

        mv termux-package.json package.json

    else

        echo -e "${R}[!] termux-package.json Not Found${N}"
        exit 1
    fi

else

    echo -e "${G}[+] Linux VPS Detected${N}"
fi

echo -e "${C}[+] Creating .env File...${N}"

cat > .env <<EOF
SESSION_ID=$SESSION_ID
EOF

echo -e "${Y}[+] Installing Modules...${N}"

npm install || {
    echo -e "${R}[!] npm install Failed${N}"
    exit 1
}

echo "true" > "$STARTUP_FILE"

echo ""
echo -e "${G}[✓] Installation Completed Successfully${N}"
echo ""

sleep 2

echo -e "${M}[+] Starting Bot With Auto Restart...${N}"

while true; do

    npm start

    echo ""
    echo -e "${R}[ SYSTEM ] Bot Crashed! Restarting In 5 Seconds...${N}"

    sleep 5

done
