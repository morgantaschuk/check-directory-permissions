# Test Directory Permissions

We've been having some issues with setting nf4_acls correctly, so I made some bash scripts to test them.

The bulk of the script is in createhierarchy.sh, which can:

* Create files and directories in two levels: DIR/**FILE**, DIR/**DIR**,
  DIR/newDIR/**FILE**, and DIR/existingDIR/**FILE** 
* Read the owner and group permissions of the new files and directories using
  `stat` and compare them to given values (-o and -g)
* Cat and touch each file
* Remove the files and the new directories


## Dependencies

* Bash, getopts

## Usage

Test everything together on directory /.mounts/labs/prod/archive/h239 (requires
the ability to `su` to sbsuser and seqprodbio):

```
bash testtwousers.sh /.mounts/labs/prod/archive/h239

```

As an individual user, you can run createhierarchy.sh yourself. This command
will create test files/dirs (-c), test the permissions (-p), and remove the
test files and dirs after completion (-r).

```
bash buildhierarchy.sh -d /.mounts/labs/prod/archive/h239/ -o seqprodbio -cpr
```

You can also create the directories with one user and test perms and remove with another:

```
$ su sbsuser
$ bash buildhierarchy.sh -d /.mounts/labs/prod/archive/h239/ -o sbsuser -c
$ su seqprodbio
$ bash buildhierarchy.sh -d /.mounts/labs/prod/archive/h239/ -o sbsuser -pr
```
