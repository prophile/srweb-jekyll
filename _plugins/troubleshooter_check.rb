module TroubleshooterChecker
    class TroubleshooterChecker < Jekyll::Generator
        def check_data(troubleshooter)
            questions = troubleshooter['questions']
            questions.each do |key, question|
                answers = question['answers']
                fail "No answers for question #{key}" if answers.empty?
                question['answers'].each do |answer|
                    next_question = answer['nextquestion']
                    fail "Undefined troubleshooter question #{next_question}" unless next_question.nil? or questions.has_key?(next_question)
                end
            end
        end

        def generate(site)
            check_data(site.data['troubleshooter'])
        end
    end
end

