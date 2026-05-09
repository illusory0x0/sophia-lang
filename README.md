# Sophia

Sophia is a statically typed functional language with Lisp syntax and ML-style types, designed as a teaching language that a single person can fully implement.

# Status 

Status: **Solo project**, maintained in spare time. I fix bugs but do **not** accept feature requests. **No PRs** please.

# Tutorial

```bash
bun interpreter.js example.sexp
```

```bash
#  user friendly stack trace
stack trace: abort
stack depth: 4
    at playground.qux example.sexp:476:5
    at playground.bar example.sexp:471:5
    at playground.foo example.sexp:485:18
    at playground.stack_trace example.sexp:500:5

```

## License

[AGPL](LICENSE)