class Chore
  class List
    include Prawn::View

    def self.build_and_save(target = :disk)
      list = new
      list.build

      if target == :disk
        list.save_to_disk
      elsif target == :s3
        list.save_to_s3
      else
        raise ArgumentError
      end

      list
    end

    def build
      stroke_color "000000"

      pages.each_with_index do |page, index|
        page.each do |section|
          draw(section)
        end

        start_new_page unless index + 1 == pages.size
      end
    end

    def save_to_disk
      local_path = "tmp/chore-list.pdf"
      save_as(local_path)
    end

    def save_to_s3
      s3_key = "chore-list.pdf"
      pdf_data = document.render
      S3Api.write(s3_key, pdf_data)
    end

    private

    def pages
      [
        [
          {assignee: "jess", due_day: 0, offset: 720},
          {assignee: "jess", due_day: 1, offset: 480},
          {assignee: "jess", due_day: 2, offset: 240}
        ],
        [
          {assignee: "jess", due_day: 3, offset: 720},
          {assignee: "jess", due_day: 4, offset: 480},
          {assignee: "jess", due_day: 5, offset: 240}
        ],
        [
          {assignee: "jess", due_day: 6, offset: 720},
          {assignee: "jack", due_day: 0, offset: 480},
          {assignee: "jack", due_day: 1, offset: 240}
        ],
        [
          {assignee: "jack", due_day: 2, offset: 720},
          {assignee: "jack", due_day: 3, offset: 480},
          {assignee: "jack", due_day: 4, offset: 240}
        ],
        [
          {assignee: "jack", due_day: 5, offset: 720},
          {assignee: "jack", due_day: 6, offset: 480}
        ]
      ]
    end

    def draw(section)
      move_cursor_to section[:offset]

      text "Chore List".upcase, style: :bold_italic, size: 42

      move_up 48

      label = "#{section[:assignee].titlecase}\n#{Date::DAYNAMES[section[:due_day]]}"
      text label, align: :right, size: 14

      move_down 3

      stroke do
        horizontal_rule
      end

      move_down 20

      chores = Chore.where(assignee: section[:assignee]).where("? = ANY(due_days)", section[:due_day])

      chores.each do |chore|
        text chore.title, size: 14
      end
    end
  end
end
