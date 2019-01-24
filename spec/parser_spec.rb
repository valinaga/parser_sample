require './parser'
require 'tempfile'

describe Parser do 
  let(:arguments) { [test_in_file.path] }

  let(:test_in_file) do
    Tempfile.new('log').tap do |f|
      pairs.each do |pair|
        f << pair.join(' ') + "\n"
      end
      f.close
    end
  end

  let(:pairs) do
    [
      ['/help_page/1', '126.318.035.038'],
      ['/contact', '184.123.665.067'],
      ['/home', '184.123.665.067'],
      ['/about/2', '444.701.448.104'],
      ['/help_page/1', '929.398.951.889'],
      ['/index', '444.701.448.104'],
      ['/help_page/1', '722.247.931.582'],
      ['/about', '061.945.150.735'],
      ['/help_page/1', '646.865.545.408'],
      ['/home', '235.313.352.950'],
      ['/contact', '184.123.665.067'],
      ['/help_page/1', '543.910.244.929'],
      ['/home', '316.433.849.805'],
      ['/about/2', '444.701.448.104'],
      ['/contact', '543.910.244.929'],
      ['/about', '126.318.035.038'],
      ['/about/2', '836.973.694.403'],
      ['/index', '316.433.849.805'],
      ['/index', '802.683.925.780'],
      ['/help_page/1', '929.398.951.889'],
      ['/contact', '555.576.836.194'],
      ['/about/2', '184.123.665.067'],
      ['/home', '444.701.448.104'],
      ['/index', '929.398.951.889'],
      ['/about', '235.313.352.950'],
      ['/contact', '200.017.277.774'],
      ['/about', '836.973.694.403'],
      ['/contact', '316.433.849.805'],
      ['/help_page/1', '929.398.951.889'],
      ['/about/2', '382.335.626.855'],
      ['/home', '336.284.013.698'],
      ['/about', '929.398.951.889'],
      ['/help_page/1', '836.973.694.403'],
      ['/contact', '836.973.694.403'],
      ['/home', '444.701.448.104'],
      ['/about/2', '543.910.244.929'],
      ['/about', '715.156.286.412'],
      ['/contact', '184.123.665.067'],
      ['/home', '444.701.448.104']
    ]
  end

  after do
    test_in_file.unlink
  end

  it 'run' do
    described_class.new(arguments).run
  end

  it 'reads sample data' do
    data = described_class.new(arguments).parse
    expect(data).to eq(
      {
        "/about" => {:uniq=>6, :visits=>6},
        "/about/2" => {:uniq=>5, :visits=>6},
        "/contact" => {:uniq=>6, :visits=>8},
        "/help_page/1" => {:uniq=>6, :visits=>8},
        "/home" => {:uniq=>5, :visits=>7},
        "/index" => {:uniq=>4, :visits=>4}
      }
    )
  end

  it 'sort visits correctly' do
    parser = described_class.new(arguments)
    parser.parse()
    res = parser.sorted(:visits)
    expect(res).to eq(["/help_page/1", "/contact", "/home", "/about/2", "/about", "/index"])
  end

  it 'sort uniq views correctly' do
    parser = described_class.new(arguments)
    parser.parse()
    res = parser.sorted(:uniq)
    expect(res).to eq(["/help_page/1", "/contact", "/about", "/home", "/about/2", "/index"])
  end

  context 'more data in the input file' do
    let(:pairs) { super() << 
      ['/about/2', '543.910.244.929'] << 
      ['/about', '543.910.244.929'] << 
      ['/contact', '543.910.244.929'] << 
      ['/index', '543.910.244.929'] 
    }
 
    it 'reade sample data' do
      data = described_class.new(arguments).parse
      expect(data).to eq(
      {
        "/about" => {:uniq=>7, :visits=>7},
        "/about/2" => {:uniq=>5, :visits=>7},
        "/contact" => {:uniq=>6, :visits=>9},
        "/help_page/1" => {:uniq=>6, :visits=>8},
        "/home" => {:uniq=>5, :visits=>7},
        "/index" => {:uniq=>5, :visits=>5}
      }
    )
    end
  
    it 'sort visits correctly' do
      parser = described_class.new(arguments)
      parser.parse()
      res = parser.sorted(:visits)
      expect(res).to eq(["/contact", "/help_page/1", "/home", "/about/2", "/about", "/index"])
    end

    it 'sort uniq views correctly' do
      parser = described_class.new(arguments)
      parser.parse()
      res = parser.sorted(:uniq)
      expect(res).to eq(["/about", "/help_page/1", "/contact", "/home", "/about/2", "/index"])
    end
  end

end

