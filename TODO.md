## translate

* [x] flashes in controllers
* [x] mails subjects
* [ ] mails templates
* [ ] app/javascripts
* [ ] app/api

## bugs

* [x] Удалять приглашение (board_member) после его принятия
* [ ] Какой-то странный баг с перетаскиванием карты
  Lane.find('a3ea8312-da0e-406c-9240-b567fa167571').cards.alive.pluck(:position)
* [ ] после перетаскивания за line title она открывается на редактирование
* [ ] Мышка руки при наведении на создаваемую колонку (должна быть мышь
  редактирования текста), не возможно выделить текст при создании колонки
* [ ] disable column dragging when edit lane title
* [ ] low height of column with scrolling, add card button override cards
* [ ] page notfound after subdomain renamed
* [ ] can't remove account membership (CSRF)

## May be

* [ ] show pencil when over account and board title for inline edit
* [x] Рефактор Invite, BoardInvite -> AccountInvite
* [ ] send board notification with active job. remove from model
* [ ] Когда task кидают в архив, его карточки тоже архивируются
* [ ] float labels http://simple-form-bootstrap.plataformatec.com.br/examples/floating_label

## TODO

4. [ ] Аттач файлов
5. [ ] Чеклист (Подзадача)
6. [ ] Цвета шапки для колонок

I Этап
------

## API

1. [x] Создание аккаунта (компании) название
2. [x] Сотрудники (имя, емайл)
3. [x] Доски (название)
4. [x] Полоски (доска, название), по-умолчанию в доске 3 полоски (todo, doing, done)
5. [x] Таски (название, детали (*), создатель,
6. [ ] Таски: ответственные (*)
7. [ ] deadline_at (*)
8. [ ] completed_at (*)
9. [ ] сколько ушло часов


II Этап
-------

1. [x] Саморегистрация пользователя (в API создание убрать). При регистрации
   автоматически создается аккаунт.
2. [x] Список пользователей в аккаунте
3. [x] Приглашние и вход по инвайту.


III Этап (13 июня)
------------------

1. [x] Я добавляю поле metadata в сущности account, board, lane, task. В поле
   можно хранить любой json
2. [x] Добавляю возможность делать выборку этих сущностей по содержимому этого
   поля.
3. [x] Добавляю возможность указывать includes (вложенную структуру сущностей
   при выборке). Чтобы можно было ,например, запросить достку и все задачи
   по ней.

IV Этап
-------

1. [x] Сохранение позиции колонки в API
2. [x] Редактирования задачи
3. [x] Коментирования по задаче https://github.com/lesha1201/simple-react-comments
3. [x] Модалка редактирования задачи
4. [ ] Комментарии: Локализация и улучшить UI
3. [ ] Установка ответственных
5. [x] Поменять название колонки (страница настройки колонки)
6. [x] Упростить создание карточки (title сделать в многострочны, убрать
   содержимое и label, изменить кнопки), autoresize title. Автосохранение по
   ENTER
7. [x] Если в карточке есть содержимое (contet) показыват это иконкой как в
   трелло. В самоу карточке показывать только title
8. [x] Убрать мелку с карточки (убуд показываться в нижней части)
9. [ ] Отказаться от модели BoardMembership
10. [ ] CardMembership:
** 1. Надо бы переименовать в TaskMembership
** 2. Автоматически добавлять пользователя в BoardMembership
