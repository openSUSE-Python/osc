import osc.commandline_git


class SSHKeyCommand(osc.commandline_git.OscGitCommand):
    """
    Manage public SSH keys
    """

    name = "ssh-key"

    def init_arguments(self):
        pass

    def run(self, args):
        self.parser.print_help()
