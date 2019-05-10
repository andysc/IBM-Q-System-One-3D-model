from qiskit import *
from qiskit.tools.monitor import job_monitor, backend_monitor, backend_overview
from qiskit.providers.ibmq import least_busy

IBMQ.load_accounts()

#backend = least_busy(IBMQ.backends())
#backend = least_busy(IBMQ.backends(filters=lambda x: not x.configuration().simulator))
backend = IBMQ.get_backend('ibmq_qasm_simulator')
#backend = IBMQ.get_backend('ibmqx4')

#print (backend.name())
#backend_monitor(backend)
#backend_overview()


q=QuantumRegister(1)
c=ClassicalRegister(1)
qc=QuantumCircuit(q,c)
qc.h(q[0])
qc.measure(q,c)

job = execute(qc, backend, shots=1)
#job_monitor(job)

print(job.result().get_counts(qc))


