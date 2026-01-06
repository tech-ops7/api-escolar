import re
import argparse

# Regex para logs no formato:
# 2025-11-18 19:12:20 ERROR Connection refused
LOG_PATTERN = re.compile(
    r"(?P<date>\d{4}-\d{2}-\d{2}) "
    r"(?P<time>\d{2}:\d{2}:\d{2}) "
    r"(?P<level>[A-Z]+) "
    r"(?P<message>.*)"
)

def parse_logs(input_file, output_file, levels):
    """
    Lê o arquivo de log e escreve no arquivo de saída
    apenas as linhas que correspondem aos níveis desejados.
    """

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            match = LOG_PATTERN.match(line)
            if match:
                level = match.group("level")
                if level in levels:
                    outfile.write(f"{match.groupdict()}\n")


def main():
    parser = argparse.ArgumentParser(description="Filtrador de logs em Python")
    parser.add_argument("--input", required=True, help="Arquivo de log de entrada")
    parser.add_argument("--output", required=True, help="Arquivo filtrado de saída")
    parser.add_argument("--levels", nargs="+", default=["ERROR", "INFO"], help="Níveis a filtrar")

    args = parser.parse_args()

    parse_logs(args.input, args.output, args.levels)
    print(f"✔ Logs filtrados salvos em: {args.output}")


if __name__ == "__main__":
    main()