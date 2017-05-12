require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    raw_students = Nokogiri::HTML(html)
    students = []

    raw_students.css('div.student-card').each do |s|
      student = {
        name: s.css('h4.student-name').text,
        location: s.css('p.student-location').text,
        profile_url: s.css('a').attribute("href").value
      }
      students << student
    end
    return students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    raw_data = Nokogiri::HTML(html)
    student = {}

    raw_data.css('div.social-icon-container').children.css('a').each do |d|
      link = d.attribute('href').value

      if d.attribute('href').value.include?('twitter')
        student[:twitter] = link
      elsif d.attribute('href').value.include?('linkedin')
        student[:linkedin] = link
      elsif d.attribute('href').value.include?('github')
        student[:github] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = raw_data.css('div.profile-quote').text
    student[:bio] = raw_data.css('div.bio-content div.description-holder p').text
    return student
  end

end
