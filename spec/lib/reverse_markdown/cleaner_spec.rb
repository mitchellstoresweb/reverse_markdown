require 'spec_helper'

describe ReverseMarkdown::Cleaner do
  let(:cleaner) { ReverseMarkdown::Cleaner.new }

  describe '#remove_newlines' do
    it 'removes more than 2 subsequent newlines' do
      result = cleaner.remove_newlines("foo\n\n\nbar")
      expect(result).to eq "foo\n\nbar"
    end

    it 'skips single and double newlines' do
      result = cleaner.remove_newlines("foo\nbar\n\nbaz")
      expect(result).to eq "foo\nbar\n\nbaz"
    end
  end

  describe '#remove_inner_whitespaces' do
    it 'removes duplicate whitespaces from the string' do
      result = cleaner.remove_inner_whitespaces('foo  bar')
      expect(result).to eq "foo bar"
    end

    it 'performs changes for multiple lines' do
      result = cleaner.remove_inner_whitespaces("foo  bar\nbar  foo")
      expect(result).to eq "foo bar\nbar foo"
    end

    it 'keeps leading whitespaces' do
      result = cleaner.remove_inner_whitespaces("    foo  bar\n    bar  foo")
      expect(result).to eq "    foo bar\n    bar foo"
    end

    it 'keeps trailing whitespaces' do
      result = cleaner.remove_inner_whitespaces("foo  \n")
      expect(result).to eq "foo  \n"
    end

    it 'keeps trailing newlines' do
      result = cleaner.remove_inner_whitespaces("foo\n")
      expect(result).to eq "foo\n"
    end

    it 'removes tabs as well' do
      result = cleaner.remove_inner_whitespaces("foo\t \tbar")
      expect(result).to eq "foo bar"
    end

    it 'keeps lines that only contain whitespace' do
      result = cleaner.remove_inner_whitespaces("foo \nbar \n \n  \nfoo")
      expect(result).to eq "foo \nbar \n \n  \nfoo"
    end
  end

  describe '#clean_punctuation_characters' do
    it 'removes whitespace between tag end and punctuation characters' do
      input = "**fat** . ~~strike~~ ? __italic__ ! "
      result = cleaner.clean_punctuation_characters(input)
      expect(result).to eq "**fat**. ~~strike~~? __italic__! "
    end
  end

  describe '#clean_tag_borders' do
    it "doesn't add whitespaces to underscore'ed elements if they are part of links" do
      input = "![im__age](sou__rce)"
      result = cleaner.clean_tag_borders(input)
      expect(result).to eq "![im__age](sou__rce)"
    end
  end
end
