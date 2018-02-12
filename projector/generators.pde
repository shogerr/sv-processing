interface SeedOperation {
    int operation(int a, int b);
}

private int operate(int a, int b, SeedOperation g)
{
    return g.operation(a, b);
}
