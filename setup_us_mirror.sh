#!/bin/bash
# Скрипт для настройки быстрых US зеркал Ubuntu

echo "🇺🇸 Настройка быстрых зеркал Ubuntu в США"

# Создаем резервную копию
sudo cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.backup

echo "📦 Создана резервная копия в ubuntu.sources.backup"

# Показываем лучшие US зеркала
echo ""
echo "🚀 ТОП-10 самых быстрых зеркал Ubuntu в США:"
echo ""
echo "1. 🥇 mirrors.gigenet.com         - GigeNET (до 1.73 MB/s)"
echo "2. 🥈 mirror.arizona.edu          - University of Arizona"
echo "3. 🥉 mirrors.xtom.com           - xTom (20 Gbps)"
echo "4. 🏅 la-mirrors.evowise.com     - Evowise Los Angeles (10 Gbps)"
echo "5. 🏅 mirrors.ocf.berkeley.edu   - UC Berkeley"
echo "6. 🏅 mirror.umd.edu             - University of Maryland"
echo "7. 🏅 ubuntu.osuosl.org          - Oregon State University"
echo "8. 🏅 mirror.cc.vt.edu           - Virginia Tech"
echo "9. 🏅 ftp.ussg.iu.edu            - Indiana University"
echo "10.🏅 mirrors.kernel.org         - Kernel.org"

echo ""
echo "🎯 Выберите зеркало:"
echo "1) GigeNET (самое быстрое)"
echo "2) xTom (20 Gbps)"
echo "3) Evowise LA (10 Gbps)"
echo "4) UC Berkeley"
echo "5) Автоматический выбор"
echo "6) Показать все US зеркала"
echo ""

read -p "Введите номер (1-6): " choice

case $choice in
    1)
        MIRROR="http://mirrors.gigenet.com/ubuntuarchive/"
        NAME="GigeNET"
        ;;
    2)
        MIRROR="https://mirrors.xtom.com/ubuntu/"
        NAME="xTom"
        ;;
    3)
        MIRROR="http://la-mirrors.evowise.com/ubuntu/"
        NAME="Evowise Los Angeles"
        ;;
    4)
        MIRROR="https://mirrors.ocf.berkeley.edu/ubuntu/"
        NAME="UC Berkeley"
        ;;
    5)
        echo "🔍 Автоматический поиск лучшего зеркала..."
        # Устанавливаем apt-select если его нет
        if ! command -v apt-select &> /dev/null; then
            echo "📦 Устанавливаем apt-select..."
            sudo apt update
            sudo apt install -y python3-pip
            pip3 install apt-select
        fi
        
        echo "⏳ Тестируем зеркала (это может занять минуту)..."
        apt-select --country US -t 1
        exit 0
        ;;
    6)
        echo ""
        echo "📋 Все US зеркала Ubuntu:"
        echo ""
        echo "🏢 Коммерческие/CDN:"
        echo "  • https://mirrors.xtom.com/ubuntu/"
        echo "  • http://mirrors.gigenet.com/ubuntuarchive/"
        echo "  • http://la-mirrors.evowise.com/ubuntu/"
        echo "  • https://la.mirrors.clouvider.net/ubuntu/"
        echo "  • http://mirrors.sonic.net/ubuntu/"
        echo ""
        echo "🎓 Университеты:"
        echo "  • http://mirror.arizona.edu/ubuntu/"
        echo "  • https://mirrors.ocf.berkeley.edu/ubuntu/"
        echo "  • https://mirror.umd.edu/ubuntu/"
        echo "  • http://ubuntu.osuosl.org/ubuntu/"
        echo "  • http://mirror.cc.vt.edu/pub2/ubuntu/"
        echo "  • https://mirror.its.umich.edu/ubuntu/"
        echo "  • http://ubuntu.cs.utah.edu/ubuntu/"
        echo "  • http://ftp.ussg.iu.edu/linux/ubuntu/"
        echo "  • http://archive.linux.duke.edu/ubuntu/"
        echo ""
        echo "🌐 Другие:"
        echo "  • http://mirrors.kernel.org/ubuntu/"
        echo "  • https://mirror.team-cymru.org/ubuntu/"
        echo "  • http://ubuntu.phoenixnap.com/ubuntu/"
        echo ""
        exit 0
        ;;
    *)
        echo "❌ Неверный выбор, используем GigeNET"
        MIRROR="http://mirrors.gigenet.com/ubuntuarchive/"
        NAME="GigeNET"
        ;;
esac

echo ""
echo "⚙️  Настраиваем зеркало: $NAME"
echo "🔗 URL: $MIRROR"

# Создаем новый sources.list
sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null << EOF
## Ubuntu зеркало: $NAME
## Настроено: $(date)

Types: deb
URIs: $MIRROR
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

## Ubuntu security updates
Types: deb
URIs: http://security.ubuntu.com/ubuntu
Suites: noble-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

echo ""
echo "🔄 Обновляем список пакетов..."
time sudo apt update

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Зеркало $NAME успешно настроено!"
    echo ""
    echo "🚀 Тестируем скорость загрузки:"
    echo "⏱️  Время обновления apt показано выше"
    echo ""
    echo "📊 Дополнительный тест скорости:"
    time sudo apt install --download-only -y htop 2>/dev/null || echo "Пакет уже установлен"
    
    echo ""
    echo "💡 Полезные команды:"
    echo "• Откат к исходному зеркалу:"
    echo "  sudo cp /etc/apt/sources.list.d/ubuntu.sources.backup /etc/apt/sources.list.d/ubuntu.sources"
    echo "• Тест другого зеркала:"
    echo "  bash $0"
    echo "• Проверка текущего зеркала:"
    echo "  grep -v '^#' /etc/apt/sources.list.d/ubuntu.sources | grep URIs"
else
    echo ""
    echo "❌ Ошибка настройки зеркала!"
    echo "🔄 Восстанавливаем исходную конфигурацию..."
    sudo cp /etc/apt/sources.list.d/ubuntu.sources.backup /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
    echo "💡 Попробуйте другое зеркало или автоматический выбор"
fi

echo ""
echo "🎯 Рекомендации по выбору зеркала:"
echo "• GigeNET - лучшая стабильность"
echo "• xTom - высокая пропускная способность (20 Gbps)"
echo "• Evowise - хорошая скорость в LA"
echo "• Berkeley - надежность университета"

# Дополнительные команды для тестирования
cat << 'EOF'

🧪 Дополнительные команды для тестирования зеркал:

# Установить netselect для тестирования задержки
sudo apt install netselect

# Протестировать топ-5 зеркал
echo "mirrors.gigenet.com
mirrors.xtom.com  
la-mirrors.evowise.com
mirrors.ocf.berkeley.edu
mirror.umd.edu" | xargs netselect

# Автоматический выбор лучшего зеркала с apt-select
pip3 install apt-select
apt-select --country US -t 3

# Тест скорости загрузки
time wget -O /dev/null http://mirrors.gigenet.com/ubuntuarchive/ls-lR.gz
EOF
