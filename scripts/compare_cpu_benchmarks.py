import re
import sys

def extract_metrics(logfile):
    metrics = {}
    with open(logfile, 'r') as f:
        content = f.read()

    # Kernel version
    kernel = re.search(r'Kernel Info\s+([\d\.\-a-z]+)', content)
    if kernel:
        metrics['kernel'] = kernel.group(1)

    # Sysbench 1-thread
    one_thread = re.search(r'Sysbench CPU Test – 1 Thread.*?events per second:\s+([\d\.]+)', content, re.DOTALL)
    if one_thread:
        metrics['sysbench_1t_eps'] = float(one_thread.group(1))

    # Sysbench 2-thread
    two_thread = re.search(r'Sysbench CPU Test – 2 Threads.*?events per second:\s+([\d\.]+)', content, re.DOTALL)
    if two_thread:
        metrics['sysbench_2t_eps'] = float(two_thread.group(1))

    # Stress-ng matrixprod
    matrixprod = re.search(r'Stress-ng CPU Test – 2 Threads \(matrixprod\).*?successful run completed in ([\d\.]+) secs', content, re.DOTALL)
    if matrixprod:
        metrics['stress_matrixprod_time'] = float(matrixprod.group(1))

    return metrics

def compare_metrics(metrics1, metrics2):
    print(f"\n📊 Porównanie wyników:\n")
    print(f"{'Metryka':<30} | {metrics1['kernel']:<15} | {metrics2['kernel']:<15}")
    print("-" * 70)

    for key in ['sysbench_1t_eps', 'sysbench_2t_eps', 'stress_matrixprod_time']:
        label = {
            'sysbench_1t_eps': 'Sysbench EPS (1 wątek)',
            'sysbench_2t_eps': 'Sysbench EPS (2 wątki)',
            'stress_matrixprod_time': 'Stress-ng czas (matrixprod)'
        }[key]

        val1 = metrics1.get(key, '—')
        val2 = metrics2.get(key, '—')

        print(f"{label:<30} | {val1:<15} | {val2:<15}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Użycie: python compare_benchmarks.py <plik1.log> <plik2.log>")
        sys.exit(1)

    file1, file2 = sys.argv[1], sys.argv[2]
    m1 = extract_metrics(file1)
    m2 = extract_metrics(file2)
    compare_metrics(m1, m2)

