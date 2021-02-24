#include-once

;"Portuguese (Brazil)"
;"English (United States)"

Global $a_language[24]
select
	Case $language = "Portuguese (Brazil)"

		$a_language[1] = "Opções do arquivo de saída."
		$a_language[2] = "Criar uma função baseada no nome de saída."
		$a_language[3] = "Adicionar padrões de Funções Definidas pelo Usuário (UDF)."
		$a_language[4] = "Apenas criar o arquivo de saída com o binário."
		$a_language[5] = "Adicionar compressão  LZNT nativa do Windows."
		$a_language[6] = "Nível de compressão:"
		$a_language[7] = "&Abrir arquivo"
		$a_language[8] = "Embutir arquivo"
		$a_language[9] = "Testar"
		$a_language[10] = "Padrão"
		$a_language[11] = "Progresso de conversão:"
		$a_language[12] = "Sair"
		$a_language[13] = "Linhas convertidas:"
		$a_language[14] = "Escolha um arquivo para embutir:"
		$a_language[15] = "O arquivo "
		$a_language[16] = " não existe!"
		$a_language[17] = 'O teste somente com a opção: "Criar uma função baseada no nome de saída" ativada!'
		$a_language[18] = "Aguarde, criando o arquivo .AU3 -> "
		$a_language[19] = "Salvar o arquivo embutido como"
		$a_language[20] = "Compactando o arquivo, aguarde..."
		$a_language[21] = " - Concluído!"
		$a_language[22] = 'O arquivo "'
		$a_language[23] = '" foi embutido para au3.'

	Case $language = "English (United States)"

		$a_language[1] = "Options for the output file."
		$a_language[2] = "Create a function based on the output name."
		$a_language[3] = "Adding patterns of User Defined Functions (UDF)."
		$a_language[4] = "Only create the output file with the binary."
		$a_language[5] = "Adding compression LZNT native Windows."
		$a_language[6] = "Compression level"
		$a_language[7] = "&Open File"
		$a_language[8] = "Embedding file"
		$a_language[9] = "Test"
		$a_language[10] = "Standard"
		$a_language[11] = "Progress of conversion:"
		$a_language[12] = "Exit"
		$a_language[13] = "Converted Lines"
		$a_language[14] = "Choose a file to embed"
		$a_language[15] = "File"
		$a_language[16] = "No!"
		$a_language[17] = 'The test only with the option: "Create a function based on the output name" activated!'
		$a_language[18] = "Wait, creating the file. AU3 equipment ->"
		$a_language[19] = "Save the file as built"
		$a_language[20] = "Compressing the file, wait ..."
		$a_language[21] = "- Done!"
		$a_language[22] = 'File" '
		$a_language[23] = '"AU3 equipment was built for."'

EndSelect
