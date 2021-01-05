# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
Student.destroy_all
Grade.destroy_all
Lesson.destroy_all

Lesson.create(day:"18.12.2020", pos:1, subject:"Math", Homework:"Ex.1")
Lesson.create(day:"18.12.2020", pos:2, subject:"Biology", Homework:"Ex.2")
Lesson.create(day:"18.12.2020", pos:3, subject:"History", Homework:"Article 5")

Lesson.create(day:"19.12.2020", pos:1, subject:"Language", Homework:"page 1")
Lesson.create(day:"19.12.2020", pos:2, subject:"Science", Homework:"Ex.2")
Lesson.create(day:"19.12.2020", pos:3, subject:"Math", Homework:"Article 5")

Student.create!(name:"Bobby", email:"bobby@example.com", password:"password")
Grade.create(value: 5, student_id: 1, lesson_id: 1)
Grade.create(value: 4, student_id: 1, lesson_id: 3)
Grade.create(value: 3, student_id: 1, lesson_id: 5)

Student.create!(name:"Alice", email:"alice@example.com", password:"password")
Grade.create(value: 5, student_id: 1, lesson_id: 3)
Grade.create(value: 2, student_id: 1, lesson_id: 6)
Grade.create(value: 5, student_id: 1, lesson_id: 2)

Student.create!(name:"LUL", email:"LUL@example.com", password:"1111111")

=end

