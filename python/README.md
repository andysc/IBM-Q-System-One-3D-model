And here's the flip.py that the exec node calls ...   
You need to have QISkit python environment (with conda, the way I've done it) 
all installed and functional first! (this is not trivial)

"go" is a script which puts you into the QISKit environment, then calls the python program.

```
source activate QISKitenv
python  flip.py
conda deactivate
```

The `go` script calls `flip.py`.

Note I've got it set up to use the cloud-based Quantum simulator
```
backend = IBMQ.get_backend('ibmq_qasm_simulator')
```

If you want to run the *local* simulator, use  
```
backend = Aer.get_backend('qasm_simulator')
```

And if you want to really really use the real Quantum computer, it takes ages, because you have to join the job queue, but...
```
backend = least_busy(IBMQ.backends(filters=lambda x: not x.configuration().simulator))
```

That line is commented out in the python script. 
But it does take a couple of minutes to run if you go that route.

You can test this bit is working, by typing `./go` from the command line. 
It should return something like:  
`{'0':1}` which mean it got one zero, i.e. tails ;)

