import { spawn } from 'node:child_process'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const scriptDir = path.dirname(fileURLToPath(import.meta.url))
const repoRoot = path.resolve(scriptDir, '..')
const vitepressCli = path.join(repoRoot, 'node_modules', 'vitepress', 'bin', 'vitepress.js')

const rawArgs = process.argv.slice(2)
const passthroughArgs = []
let host = null
let port = null

for (let index = 0; index < rawArgs.length; index += 1) {
  const arg = rawArgs[index]

  if (arg === '--host') {
    host = rawArgs[index + 1] ?? host
    index += 1
    continue
  }

  if (arg.startsWith('--host=')) {
    host = arg.slice('--host='.length) || host
    continue
  }

  if (arg === '--port') {
    port = rawArgs[index + 1] ?? port
    index += 1
    continue
  }

  if (arg.startsWith('--port=')) {
    port = arg.slice('--port='.length) || port
    continue
  }

  passthroughArgs.push(arg)
}

const npmHost = process.env.npm_config_host
const npmPort = process.env.npm_config_port

if (!host && npmHost && npmHost !== 'true') {
  host = npmHost
}

if (!port && npmPort && npmPort !== 'true') {
  port = npmPort
}

if (!host && passthroughArgs[0] && Number.isNaN(Number(passthroughArgs[0]))) {
  host = passthroughArgs.shift()
}

if (!port && passthroughArgs[0] && /^\d+$/.test(passthroughArgs[0])) {
  port = passthroughArgs.shift()
}

const cliArgs = ['dev', '.', ...passthroughArgs]

if (host) {
  cliArgs.push('--host', host)
}

if (port) {
  cliArgs.push('--port', port)
}

const child = spawn(process.execPath, [vitepressCli, ...cliArgs], {
  cwd: repoRoot,
  stdio: 'inherit',
})

child.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal)
    return
  }

  process.exit(code ?? 1)
})
