class Employee
  attr_reader :salary
  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(mult)
    @salary * mult
  end
end

class Manager < Employee

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

end

scott = Employee.new("Scott", "Student", 3*, "Ned")
manager = Manager.new("Ned", "Founder", 10000000, "Kush", [scott])
p scott.bonus(5)
p manager.salary
p manager.bonus(2)
