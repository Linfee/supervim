import time
import pynvim

@pynvim.plugin
class TestPlugin:

    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.function('TestFunction', sync=False)
    def test_function(self, args):
        for i in range(10):
            self.nvim.current.buffer.append(str(i))
            time.sleep(1)

    @pynvim.command('TestCommand', nargs='*', range='', sync=False)
    def test_command(self, args, _range):
        # self.nvim.current.buffer.append('Command with args: {}, range: {}'.format(args, _range))
        for i in range(10):
            self.nvim.current.buffer.append(str(i))
            time.sleep(1)

    @pynvim.autocmd('BufEnter', pattern='*.py', eval='expand("<afile>")', sync=True)
    def on_buf_enter(self, filename):
        self.nvim.out_write('testplugin is in ' + filename + '\n')
