# sistema_de_reservas_lpdm
Sistema de Reservas (BookingApp), desenvolvido em Flutter para o trabalho final da disciplina de Laboratório de Dispositivos Móveis 2024.2

A ideia é desenvolver um Aplicativo para Smartphone (Android) que consiga seguir os seguintes requisitos:

Desenvolver um sistema de Reservas composto por dois aplicativos. O primeiro aplicativo é destinado a cadastro de propriedades, onde o usuário precisa se cadastrar para logar no sistema e poderá criar, listar, editar e remover suas propriedades a serem reservadas. Ao cadastrar uma propriedade, será necessário incluir um endereço que deve ser preenchido pela busca de informações da api viacep ao submeter um cep como entrada, conforme visto em sala de aula.
Link da api viacep: https://viacep.com.br/

As informações retornadas do cep pelo viacep devem ser armazenadas na tabela Address descrita abaixo, considerando o cep como registro único, isto é, não pode conter duas linhas com informações do mesmo cep. No cadastro de uma propriedade, o usuário poderá incluir várias imagens da mesma que deverão ser armazenadas na tabela Images e é necessário ter uma imagem (thumbnail) principal da propriedade cadastrada na tabela Property. Ao excluir uma propriedade é necessário excluir todas as reservas da propriedade registradas na tabela Booking.

O segundo aplicativo é destinado aos usuários que vão buscar uma propriedade para fazer uma reserva. Também é necessário criar um cadastro do usuário para poder logar no sistema e permitir fazer uma reserva. A primeira tela do App deve mostrar a opção de logar no sistema, cadastrar novo usuário ou logar sem cadastro. 

Uma vez que o usuário tenha escolhido sua opção, ele será redirecionado para tela de busca que deve listar as propriedades com os maiores ratings. A tela de busca deve apresentar os filtros de UF, cidade, bairro, data de check-in, data de check-out e quantidade de pessoas com um botão para buscar propriedades com base nos filtros e um menu com as seguintes opções:
- Deslogar;
- Minhas Reservas;

O resultado da busca na Tela de busca deve listar todas as propriedades de acordo com a filtragem do usuário, indicando a thumbnail da propriedade, o título, rating(média da tabela booking) e o preço. Os campos de data de check-in e check-out devem ser usados para selecionar a propriedade que não tem reserva na data informada cadastrada na tabela Booking.

Ao clicar na propriedade listada, o usuário será direcionado para tela de detalhes da propriedade onde deve mostrar todas as informações da propriedade e ter um botão para fazer uma reserva. A realização de uma reserva deve criar um registro na tabela Booking, onde os campos de dias totais e preço total deve ser calculados automaticamente com base no preço da propriedade.

Ao clicar na opção de Minhas Reservas, o usuário deve ser encaminhado para a tela que mostra todas suas reservas.

Deve utilizar a api sqflite ou sqflite_common_ffi para implementar as tabelas no SQLlite.

Para armazenar os dados dos usuários e as tarefas, deve-se criar as seguintes tabelas no SQL Lite (anexo script.txt):

Tabela User:
- id;
- name;
- email;
- password;

Tabela Address:
- id;
- cep;
- logradouro;
- bairro;
- localidade;
- uf;
- estado;

Tabela Property
- id;
- user_id; (Correspondente a chave id da tabela User)
- address_id; (Correspondente a chave id da tabela Address)
- title;
- description;
- number;
- complement;
- price; (valor da diária)
- max_guest;
- thumbnail;

Tabela Images:
- id;
- property_id; (Correspondente a chave id da tabela Property)
- path; 

Tabela Booking
- id;
- user_id; (Correspondente a chave id da tabela User)
- property_id; (Correspondente a chave id da tabela Property)
- checkin_date;
- checkout_date;
- total_days;
- total_price;
- amount_guest;
- rating;

