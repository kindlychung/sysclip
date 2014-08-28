python <<EOF
# -*- coding: utf-8 -*-

import subprocess
import vim

def passStrNc(myString):
    cmd = """let @" = '{0}' """.format(myString.replace("'", "''"))
    vim.command(cmd)
    p = subprocess.Popen(["nc", "localhost", "2224"], stdin=subprocess.PIPE)
    out, err = p.communicate(input = myString.encode())


def passLineNc():
    line = vim.current.line + "\n"
    passStrNc(line)


def getRange():
    buf = vim.current.buffer
    (lnum1, col1) = buf.mark('<')
    (lnum2, col2) = buf.mark('>')
    lines = vim.eval('getline({}, {})'.format(lnum1, lnum2))
    lines[0] = lines[0][col1:]
    lines[-1] = lines[-1][:col2+1]
    return "\n".join(lines) + "\n"

def passSelection():
    selection = getRange()
    passStrNc(selection)

def delLine():
    line = vim.current.line
    passStrNc(line)
    vim.command("del")

def delSelection():
    buf = vim.current.buffer
    (lnum1, col1) = buf.mark('<')
    (lnum2, col2) = buf.mark('>')

    # get selected text
    lines = vim.eval('getline({}, {})'.format(lnum1, lnum2))
    lines[0] = lines[0][col1:]
    lines[-1] = lines[-1][:col2+1]
    selected =  "\n".join(lines) + "\n"
    passStrNc(selected)

    # delete selected text
    lnum1 -= 1
    lnum2 -= 1
    firstSeletedLineNew = buf[lnum1][:col1]
    lastSelectedLineNew = buf[lnum2][(col2 + 1):]
    newBuf = ["" for i in range(lnum2 - lnum1 + 1)]
    newBuf[0] = firstSeletedLineNew
    newBuf[-1] = lastSelectedLineNew
    buf[lnum1:(lnum2 + 1)] = newBuf
    del buf[(lnum1 + 1):lnum2]

EOF




function! PassLineToNc()
python <<EOF
passLineNc()
EOF
endfunction

function! PassSelection()
python << EOF
passSelection()
EOF
endfunction

function! DelLine()
python << EOF
delLine()
EOF
endfunction

function! DelSelection()
python << EOF
delSelection()
EOF
endfunction

python << EOF
import os
sshTty = os.getenv("SSH_TTY")
sty = os.getenv("STY")
if sshTty or sty:
    cmd1 = "nnoremap yy :call PassLineToNc()<cr>"
    cmd2 = "nnoremap Y :call PassLineToNc()<cr>"
    cmd3 = "vnoremap y :call PassSelection()<cr>"
    cmd4 = "nnoremap dd :call DelLine()<cr>"
    cmd5 = "nnoremap D :call DelLine()<cr>"
    cmd6 = "vnoremap d <esc>:call DelSelection()<cr>"
    vim.command(cmd1)
    vim.command(cmd2)
    vim.command(cmd3)
    vim.command(cmd4)
    vim.command(cmd5)
    vim.command(cmd6)
EOF
