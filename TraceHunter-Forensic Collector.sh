#!/bin/bash
echo -e "\033[1;34m TraceHunter-Forensic Collector \033[0m"

# verificação do script, para saber se está rodando como root ou não
if [[ $EUID -ne 0 ]]; then
	echo -e "\033[1;31m Este script precisa ser executado como root. \033[0m"
	exit 1
fi

# criar um diretório para os arquivos que serão coletados
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

# exibindo a mensagem de início
echo -e "\033[1;35m Coletando arquivos do sistema... \033[0m"

# exibindo a segunda mensagem
echo -e "\033[0;95m Listando informações sobre discos e partições... \033[0m"

# coletando as informações do disco/partição
lsblk > "$COLLECTED_DIR/disk_info.txt"

# exibindo a terceira mensagem
echo -e "\033[0;95m Coletando informações de rede... \033[0m"

# capturando conexões ativas
ss -tulnp > "$COLLECTED_DIR/active_connections.txt"

# capturando portas abertas
netstat -tulnp > "$COLLECTED_DIR/open_ports.txt"

# exibindo a quarta mensagem
echo -e "\033[0;95m Coletando lista de processos... \033[0m"

# coletando lista de processos
ps aux > "$COLLECTED_DIR/process_list.txt"

# exibindo a quinta mensagem
echo -e "\033[0;95m Coletando logs do sistema... \033[0m"

# copiando logs relevantes
cp /var/log/syslog "$COLLECTED_DIR/syslog.log"
cp /var/log/auth.log "$COLLECTED_DIR/auth.log"
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log"

# exibindo a sexta mensagem
echo -e "\033[0;95m Coletando arquivos de configuração... \033[0m"

# coletando arquivos de configuração
cp -r /etc "$COLLECTED_DIR"

# exibindo a sétima mensagem
echo -e "\033[0;95m Listando o diretório raíz... \033[0m"

# criando o arquivo da lista do diretório
ls -la / "$COLLECTED_DIR" > "$COLLECTED_DIR/root_dir_list.txt"

# zipando
tar -czf "TraceHunter_{Hostname}_{DataHora}.tar.gz" "$COLLECTED_DIR"
