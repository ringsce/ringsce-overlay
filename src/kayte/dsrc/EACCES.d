module kaytec.EACCES;
extern(C) {
    import core.stdc.errno : EACCES;
    import core.stdc.stdio : perror;
}

void main() {
    perror("FILE");
}
