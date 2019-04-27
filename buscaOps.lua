--importa as funções para a fila
queue = require "Fila"

--cria a tabela "busca"
busca = {} 
--variáveis necessárias
busca.cor = {} --mostra a cor de cada vértice
busca.d = {} --mostra o tempo de descoberta (em ticks)
busca.f = {} --mostra o tempo de  (em ticks)
busca.pi = {} --mostra o vértice antecessor do vértice analisado
busca.tempo = 0
busca.marcado = {}
busca.id = {}
busca.cont = 0

--realiza a busca em profundidade (recursivo)
function busca.dfs(grafo)
	for i=1, #grafo.listaAdj do --percorre todos os vértices do grafo
		busca.cor[i] = "branco" --pinta os vértice de branco (não visitado)
		busca.pi[i] = {nil} --define o vértice anterior como nulo
		busca.d[i] = 0
		busca.f[i] = 0
		--table.insert(tempo.d[i], {})
		--[[for j=1, #grafo.listaAdj[i] do
			cor[i][j] = "branco"
			pi[i][j] = nil
		end]]
	end
	busca.tempo = 0
	for i=1, #grafo.listaAdj do --percorre todos os vértices
		if busca.cor[i] == "branco" then
			busca.dfsVisita(grafo, i)
		end
	end
    --print("dfs ok")
end

--visita todos os vértices do grafo
function busca.dfsVisita(grafo, i)
	busca.cor[i] = "cinza" --sinaliza que o vértice já foi visitado
	busca.tempo = busca.tempo + 1 --incrementa o tempo
	busca.d[i] = busca.tempo
	for v=1, #grafo.listaAdj[i] do
		if busca.cor[v] == "branco" then
			busca.pi[v] = i
			busca.dfsVisita(grafo, v)
		end
	end
	busca.cor[i] = "preto"
	busca.f[i] = busca.tempo + 1
end

function busca.bfs(grafo, s)
    --Define para todos os vértices, menos a fonte: cor, distância do veŕtice em relação à fonte e o vértice antecessor
    for u=1, #grafo.listaAdj do
        if u ~= s then
			busca.cor[u] = "branco"
			busca.d[u] = nil
			busca.pi[u] = nil
		end
    end
    busca.cor[s] = "cinza"
    busca.d[s] = 0
    busca.pi[s] = nil --o vértice fonte não tem antecessor
    Q = queue.new() --cria uma nova fila
    queue.coloca(Q, s)
    while Q.first < Q.last do -- se a fila não estiver vazia
        u = queue.retira(Q) -- retira o elemento da fila
        for v=1, #grafo.listaAdj[u] do -- percorre a lista de adjacência do vértice
            if busca.cor[v] == "branco" then
                busca.cor[v] = "cinza"
                busca.d[v] = busca.d[u] + 1 --a distância deste vértice é antecessor + 1
                busca.pi[v] = u --o vértice antecessor de v é u
                queue.coloca(Q, v) --põe o vértice v na fila e recomeça o ciclo
            end
        end
        busca.cor[u] = "preto"
    end
    --print("bfs ok")
end

function busca.conectado_p1(grafo)
	busca.marcado[1]=true
	for s=1, #grafo.listaAdj do
		if busca.marcado[s]~=true then
			busca.conectado_p2(grafo, s)
			busca.cont = busca.cont + 1
		end
	end
end

function busca.conectado_p2(grafo, v)
	busca.marcado[v] = true
	busca.id[v] = busca.cont
	for w=1, #grafo.listaAdj do
		if busca.marcado[w]~=true then
			busca.conectado_p2(grafo, w)
		end
	end
end

function busca.conectado(v, w)
	return busca.id[v]==busca.id[w]
end

return busca