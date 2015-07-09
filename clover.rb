require 'json'

INPUT = "input.json"
OUTPUT = "output.json"
NUM_MATCHES = 10
@imp = {0 => 0, 1 => 1, 2 => 10, 3 => 50, 4 => 250}


def to_json filename
	file = IO.read filename
	JSON.parse file
end


def get_common id_1, id_2
	@ques[id_1] & @ques[id_2]
end


def get_ans profileId, quesId
	i = @ques[profileId].index quesId
	@ans[profileId][i]
end


def satisfaction master, slave, common
	score = 0.0
	total = 0.0

	common.each do |c|
		i = @ques[slave].index c
		j = @ques[master].index c

		ans_m = get_ans master, c
		ans_s = get_ans slave, c

		accepted = ans_m['acceptableAnswers']
		importance = @imp[ans_m['importance']]
		
		if accepted.size == 0 or accepted.size == 4
			importance = 0
		end

		if accepted.include? ans_s['answer']
			score += importance
		end
		total += importance
	end

	score / total
end


def get_score id_1, id_2
	common = get_common id_1, id_2
	sat_1 = satisfaction id_1, id_2, common
	sat_2 = satisfaction id_2, id_1, common

	calc = Math.sqrt sat_1 * sat_2
	err = 1 / common.length
	((calc - err) * 100).round / 100.0
end



def filter_results
	@raw_matches.sort.each do |key, val|
		res = {:profileId => key, :matches => Array.new}

		val.sort_by{ |k, v| -v }.first(NUM_MATCHES).map.each do |k, v|
			match = {:profileId => k, :score => v}
			res[:matches].push match
		end

		@output[:results].push res
	end
end


def find_matches profiles
	profiles.each do |d|
		id = d['id']
		@raw_matches[id] = Hash.new

		@ans[id] = d['answers']

		q = Array.new
		@ans[id].each do |a|
			q.push a['questionId']
		end

		@ques[id] = q

		@ans.keys.each do |k|
			if id != k
				score = get_score id, k
				@raw_matches[id][k] = score
				@raw_matches[k][id] = score
			end
		end
	end
end


# separate structure for questions of each id helps
# determine common questions b/w profiles quickly
@ques = Hash.new
@ans = Hash.new
@raw_matches = Hash.new
@output = {:results => Array.new}

$stdout.write "Generating results...\n"

profiles = to_json(INPUT)['profiles']
find_matches profiles
filter_results

$stdout.write "Storing results in #{OUTPUT}...\n"

File.open(OUTPUT,"w") do |f|
  f.write JSON.pretty_generate(@output)
end

$stdout.write "Program complete.\n"