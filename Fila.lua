--cria uma fila com funções de colocar e retirar itens
Fila = {}
function Fila.new()
    return {first = 0, last = -1}
end
--põe um elemento na fila
function Fila.coloca (fila, valor)
    local last = fila.last + 1 --aumenta o tamanho da lista
    fila.last = last
    fila[last] = valor --adiciona o valor no ultimo lugar da fila
end
--retira um elemento da fila
function Fila.retira(fila)
    local first = fila.first
    --if first > fila.last then error("list is empty") end
    local valor = fila[first]
    fila[first] = nil -- limpa o primeiro item da fila
    fila.first = first + 1
    return valor
end

return Fila
